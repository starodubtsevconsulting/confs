#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "$script_dir/.." && pwd)"
users_conf_file="$root_dir/git/.users-list.conf"

usage() {
  echo "Usage: $0" >&2
  echo "Authenticates GitHub CLI (gh) using PAT from git/.users-list.conf." >&2
  echo "It matches the entry by repo-local: git config github.user" >&2
}

if [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  usage
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is not installed." >&2
  exit 1
fi

if [ ! -f "$users_conf_file" ]; then
  echo "Missing config: $users_conf_file" >&2
  echo "Create it based on git/.users-list.conf.example and re-run ./git/switch-user.sh." >&2
  exit 2
fi

github_user="$(git -C "$root_dir" config github.user 2>/dev/null || true)"

selected_gh=""
selected_token=""
selected_count=0
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|\#*)
      continue
      ;;
  esac

  IFS='|' read -r label name email entry_gh entry_token <<<"$line"
  if [ -n "${entry_gh:-}" ] && [ -n "${entry_token:-}" ]; then
    selected_gh="$entry_gh"
    selected_token="$entry_token"
    selected_count=$((selected_count + 1))
  fi
done < "$users_conf_file"

if [ -z "$github_user" ]; then
  if [ "$selected_count" -eq 1 ]; then
    github_user="$selected_gh"
    git -C "$root_dir" config github.user "$github_user"
    git -C "$root_dir" config credential.username "$github_user"
  else
    echo "Repo-local github.user is not set." >&2
    echo "Run ./git/switch-user.sh to select a profile, or ensure git/.users-list.conf has exactly one entry with github user + token." >&2
    exit 2
  fi
fi

found_token=""
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|\#*)
      continue
      ;;
  esac

  IFS='|' read -r label name email entry_gh entry_token <<<"$line"

  if [ "${entry_gh:-}" = "$github_user" ]; then
    found_token="${entry_token:-}"
    break
  fi

done < "$users_conf_file"

if [ -z "$found_token" ]; then
  echo "No PAT token found for github.user=$github_user in $users_conf_file" >&2
  echo "Expected format: label|name|email|github_user|github_token" >&2
  exit 2
fi

printf "%s" "$found_token" | gh auth login --with-token

echo "gh authenticated for github.com (user: $github_user)"
