#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "$script_dir/.." && pwd)"
users_conf_file="$script_dir/.users-list.conf"

usage() {
  echo "Usage: $0 [--name <name>] [--email <email>]" >&2
  echo "Sets git user.name and user.email for this repo only (no --global)." >&2
}

name=""
email=""
github_user=""
github_token=""

while [ $# -gt 0 ]; do
  case "$1" in
    --name)
      name="${2-}"
      shift 2
      ;;
    --email)
      email="${2-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

select_from_user_list() {
  if [ ! -f "$users_conf_file" ]; then
    return 1
  fi

  local -a GIT_USER_LIST=()
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|\#*)
        continue
        ;;
    esac
    GIT_USER_LIST+=("$line")
  done < "$users_conf_file"

  if [ "${#GIT_USER_LIST[@]}" -eq 0 ]; then
    return 1
  fi

  echo "Available git identities:" >&2
  local i=1
  local entry label entry_name entry_email entry_gh entry_token
  parse_entry() {
    local in="$1"
    local f1 f2 f3 f4 f5
    IFS='|' read -r f1 f2 f3 f4 f5 <<<"$in"
    label="$f1"
    entry_name="$f2"
    entry_email="$f3"
    entry_gh="$f4"
    entry_token="$f5"
  }
  for entry in "${GIT_USER_LIST[@]}"; do
    parse_entry "$entry"
    if [ -n "$entry_gh" ]; then
      printf "  %d) %s (%s <%s>) gh:%s\n" "$i" "$label" "$entry_name" "$entry_email" "$entry_gh" >&2
    else
      printf "  %d) %s (%s <%s>)\n" "$i" "$label" "$entry_name" "$entry_email" >&2
    fi
    i=$((i + 1))
  done
  echo "" >&2
  printf "Choose identity by number, label, or github username (or press Enter for manual): " >&2
  read -r choice

  if [ -z "$choice" ]; then
    return 1
  fi

  if [[ "$choice" =~ ^[0-9]+$ ]]; then
    if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#GIT_USER_LIST[@]}" ]; then
      return 1
    fi
    entry="${GIT_USER_LIST[$((choice - 1))]}"
    parse_entry "$entry"
    name="$entry_name"
    email="$entry_email"
    github_user="$entry_gh"
    github_token="$entry_token"
    return 0
  fi

  for entry in "${GIT_USER_LIST[@]}"; do
    parse_entry "$entry"
    if [ "$label" = "$choice" ] || { [ -n "$entry_gh" ] && [ "$entry_gh" = "$choice" ]; }; then
      name="$entry_name"
      email="$entry_email"
      github_user="$entry_gh"
      github_token="$entry_token"
      return 0
    fi
  done

  return 1
}

if [ -z "$name" ] || [ -z "$email" ]; then
  select_from_user_list || true
fi

if [ -z "$name" ]; then
  printf "Git user.name for this repo: " >&2
  read -r name
fi

if [ -z "$email" ]; then
  printf "Git user.email for this repo: " >&2
  read -r email
fi

if [ -z "$name" ] || [ -z "$email" ]; then
  echo "Both user.name and user.email are required." >&2
  exit 2
fi

git -C "$root_dir" config user.name "$name"
git -C "$root_dir" config user.email "$email"
if [ -n "${github_user:-}" ]; then
  git -C "$root_dir" config github.user "$github_user"
  git -C "$root_dir" config credential.username "$github_user"
fi

if [ -n "${github_user:-}" ] && [ -n "${github_token:-}" ]; then
  git -C "$root_dir" config credential.helper store

  creds_file="$HOME/.git-credentials"
  tmp_file="$(mktemp)"

  if [ -f "$creds_file" ]; then
    # Remove any existing GitHub entry; keep all other credentials.
    grep -vE '^https://[^@]+@github\.com/?$' "$creds_file" > "$tmp_file" || true
  fi

  printf "https://%s:%s@github.com\n" "$github_user" "$github_token" >> "$tmp_file"
  mv "$tmp_file" "$creds_file"
  chmod 600 "$creds_file" || true
fi

echo "Repo-local git identity set:"
echo "  user.name:  $(git -C "$root_dir" config user.name)"
echo "  user.email: $(git -C "$root_dir" config user.email)"
if git -C "$root_dir" config github.user >/dev/null 2>&1; then
  echo "  github.user: $(git -C "$root_dir" config github.user)"
fi
if git -C "$root_dir" config credential.username >/dev/null 2>&1; then
  echo "  credential.username: $(git -C "$root_dir" config credential.username)"
fi
if git -C "$root_dir" config credential.helper >/dev/null 2>&1; then
  echo "  credential.helper: $(git -C "$root_dir" config credential.helper)"
fi
