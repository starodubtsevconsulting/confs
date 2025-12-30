#!/usr/bin/env bash
set -euo pipefail

NAME="starodubtsevconsulting"
EMAIL="sergii@starodubtsev.consulting"

usage() {
  echo "Usage: $(basename "$0") <branch>"
  echo "Rewrites all commits on the given branch to author/committer: ${NAME} <${EMAIL}>"
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

BRANCH=${1:-}
if [[ -z "$BRANCH" ]]; then
  echo "Error: branch is required."
  usage
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository."
  exit 1
fi

if ! git show-ref --verify --quiet "refs/heads/${BRANCH}" && ! git show-ref --verify --quiet "refs/remotes/${BRANCH}"; then
  if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
    echo "Error: branch not found: $BRANCH"
    exit 1
  fi
fi

cat <<INFO
Rewriting all commits reachable from: $BRANCH
New author/committer: ${NAME} <${EMAIL}>

This rewrites history. You will need to force-push the branch.
INFO

read -r -p "Continue? [y/N]: " reply
case "$reply" in
  [Yy]*) ;;
  *) echo "Aborted."; exit 1 ;;
esac

export GIT_AUTHOR_NAME="$NAME"
export GIT_AUTHOR_EMAIL="$EMAIL"
export GIT_COMMITTER_NAME="$NAME"
export GIT_COMMITTER_EMAIL="$EMAIL"

git filter-branch --force --env-filter '
GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME";
GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL";
GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME";
GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL";
' -- "$BRANCH"

echo "Done. If branch is pushed, run: git push --force-with-lease"
