#!/usr/bin/env bash
#
# gh-auth.command.sh
#
# Generic GitHub CLI authentication wrapper for AI agents.
# This script is designed to be used from ANY repository/project, not just ~/confs.
# It facilitates secure authentication without exposing GitHub tokens to AI agents.
#
# Purpose:
#   - AI agents can call this script to authenticate GitHub CLI (gh)
#   - Credentials are read from a centralized config file (not exposed to AI)
#   - Works from any working directory
#
# Usage from any repo:
#   bash ~/confs/.ai/scripts/gh-auth.command.sh [path-to-users-list.conf]
#
# Config file priority:
#   1) Command line parameter
#   2) CONFS_USERS_LIST environment variable
#   3) Relative to script: $script_dir/../git/.users-list.conf
#   4) Fallback: ~/confs/git/.users-list.conf
#
# Example from AI agent:
#   "To authenticate GitHub CLI, run: bash ~/confs/.ai/scripts/gh-auth.command.sh"
#

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "$script_dir/../.." && pwd)"

# Allow override via environment variable or parameter
# Priority: 1) Parameter, 2) CONFS_USERS_LIST env var, 3) Relative to script, 4) ~/confs/git fallback
if [ -n "${1:-}" ] && [ "$1" != "-h" ] && [ "$1" != "--help" ]; then
  users_conf_file="$1"
elif [ -n "${CONFS_USERS_LIST:-}" ]; then
  users_conf_file="$CONFS_USERS_LIST"
elif [ -f "$root_dir/git/.users-list.conf" ]; then
  users_conf_file="$root_dir/git/.users-list.conf"
elif [ -f "$HOME/confs/git/.users-list.conf" ]; then
  users_conf_file="$HOME/confs/git/.users-list.conf"
else
  users_conf_file="$root_dir/git/.users-list.conf"
fi

usage() {
  echo "Usage: $0 [path-to-users-list.conf]" >&2
  echo "" >&2
  echo "Generic GitHub CLI authentication wrapper for AI agents." >&2
  echo "Authenticates GitHub CLI (gh) using PAT from .users-list.conf." >&2
  echo "Can be called from ANY repository/project." >&2
  echo "" >&2
  echo "Config file priority:" >&2
  echo "  1) Command line parameter" >&2
  echo "  2) CONFS_USERS_LIST environment variable" >&2
  echo "  3) Relative to script: \$script_dir/../git/.users-list.conf" >&2
  echo "  4) Fallback: ~/confs/git/.users-list.conf" >&2
  echo "" >&2
  echo "It matches the entry by repo-local: git config github.user" >&2
  echo "" >&2
  echo "Example from any repo:" >&2
  echo "  cd ~/my-project" >&2
  echo "  bash ~/confs/.ai/scripts/gh-auth.command.sh" >&2
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh (GitHub CLI) is not installed." >&2
  echo "Install it from: https://cli.github.com/" >&2
  exit 1
fi

if [ ! -f "$users_conf_file" ]; then
  echo "Missing config: $users_conf_file" >&2
  echo "Create it based on git/.users-list.conf.example" >&2
  echo "" >&2
  echo "You can specify the config file location via:" >&2
  echo "  - Command line: $0 /path/to/.users-list.conf" >&2
  echo "  - Environment: export CONFS_USERS_LIST=/path/to/.users-list.conf" >&2
  exit 2
fi

echo "Using config file: $users_conf_file"

github_user="$(git config github.user 2>/dev/null || true)"

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
    git config github.user "$github_user"
    git config credential.username "$github_user"
  else
    echo "Repo-local github.user is not set." >&2
    echo "Ensure git/.users-list.conf has exactly one entry with github user + token." >&2
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

echo "✅ gh authenticated for github.com (user: $github_user)"
