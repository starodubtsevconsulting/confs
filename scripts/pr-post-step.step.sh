#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage:
  pr-post-step.step.sh <branch-name>

Does (post-merge cleanup):
  - checkout main
  - fetch origin
  - reset --hard origin/main
  - delete local branch
  - delete remote branch (if exists)

Notes:
  - Run this only AFTER the PR is merged.
  - Branch deletion may fail if the branch is not fully merged locally; in that case use -D.
USAGE
}

if [ "$#" -ne 1 ]; then
  usage
  exit 2
fi

branch_name="$1"

if [ "$branch_name" = "main" ]; then
  echo "Refusing to delete main." >&2
  exit 2
fi

# Sync main

git checkout main

git fetch origin

git reset --hard origin/main

# Delete local branch
if git show-ref --verify --quiet "refs/heads/$branch_name"; then
  git branch -d "$branch_name" || git branch -D "$branch_name"
fi

# Delete remote branch if it exists
if git ls-remote --exit-code --heads origin "$branch_name" >/dev/null 2>&1; then
  git push origin --delete "$branch_name"
fi
