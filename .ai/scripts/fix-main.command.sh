#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE' >&2
Usage:
  fix-main.step.sh [--stash] [--yes]

Purpose:
  Repair the local repo when you accidentally committed/edited on `main`.

What it does:
  - (optional) stashes uncommitted changes (including untracked) if --stash is provided
  - creates a salvage branch at the current local main HEAD
  - fetches origin
  - hard-resets local main to origin/main (clean + synced)

Options:
  --stash   stash working tree changes before resetting main
  --yes     do not prompt (DANGEROUS)
USAGE
}

stash_first=0
auto_yes=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --stash)
      stash_first=1
      shift
      ;;
    --yes)
      auto_yes=1
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

current_branch="$(git branch --show-current)"
if [ "$current_branch" != "main" ]; then
  echo "Not on main (current: $current_branch). Aborting." >&2
  exit 2
fi

if [ "$stash_first" -eq 1 ]; then
  git stash push -u -m "wip: fix-main.step.sh"
fi

salvage_branch="salvage/main-$(date +%Y%m%d-%H%M%S)"
git branch "$salvage_branch"

echo "Created salvage branch: $salvage_branch"

git fetch origin

echo "About to run: git reset --hard origin/main"
if [ "$auto_yes" -ne 1 ]; then
  printf "Proceed? [Y/NO]: "
  read -r choice
  if [ "${choice^^}" != "Y" ]; then
    echo "Aborting."
    exit 0
  fi
fi

git reset --hard origin/main

echo "main is now synced to origin/main"
