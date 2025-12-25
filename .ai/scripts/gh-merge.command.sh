#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage:
  gh-merge.step.sh <PR_NUMBER> [--no-delete-branch] [--sync-main]

Default behavior:
  - Squash-merge the PR using GitHub CLI (gh)
  - Delete the remote branch on merge

Options:
  --no-delete-branch  Do not delete the remote branch after merge
  --sync-main         After merge: checkout main, fetch origin, hard-reset to origin/main

Notes:
  - PR comments/discussion are preserved automatically by GitHub.
USAGE
}

if [ "$#" -lt 1 ]; then
  usage
  exit 2
fi

pr_number="$1"
shift

delete_branch=1
sync_main=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-delete-branch)
      delete_branch=0
      shift
      ;;
    --sync-main)
      sync_main=1
      shift
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

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is not installed." >&2
  exit 1
fi

info_json="$(gh pr view "$pr_number" --json state,mergeable,mergeStateStatus,url 2>/dev/null || true)"
if [ -z "$info_json" ]; then
  echo "Unable to read PR #$pr_number. Are you authenticated to gh?" >&2
  exit 1
fi

merge_args=("$pr_number" --squash)
if [ "$delete_branch" -eq 1 ]; then
  merge_args+=(--delete-branch)
fi

gh pr merge "${merge_args[@]}"

echo "Merged PR #$pr_number"

if [ "$sync_main" -eq 1 ]; then
  git checkout main
  git fetch origin
  git reset --hard origin/main
fi
