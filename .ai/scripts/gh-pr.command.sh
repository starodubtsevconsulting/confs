#!/usr/bin/env bash
#
# gh-pr.command.sh
#
# Generic GitHub PR creation wrapper for AI agents.
# This script is designed to be used from ANY repository/project, not just ~/confs.
# It facilitates PR creation without exposing GitHub tokens to AI agents.
#
# Purpose:
#   - AI agents can call this script to create GitHub Pull Requests
#   - Authenticates using gh-auth.command.sh (credentials not exposed to AI)
#   - Works from any working directory
#   - Uses --fill to auto-populate PR title/body from commits
#
# Usage from any repo:
#   cd ~/my-project
#   git checkout feature/my-branch
#   git push -u origin HEAD
#   bash ~/confs/.ai/scripts/gh-pr.command.sh
#
# Prerequisites:
#   - Branch must be pushed to origin
#   - GitHub CLI (gh) must be installed
#   - ~/confs/git/.users-list.conf must be configured
#
# Example from AI agent:
#   "To create the PR, run: bash ~/confs/.ai/scripts/gh-pr.command.sh"
#

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0" >&2
  echo "" >&2
  echo "Generic GitHub PR creation wrapper for AI agents." >&2
  echo "Creates a Pull Request using GitHub CLI (gh)." >&2
  echo "Can be called from ANY repository/project." >&2
  echo "" >&2
  echo "Prerequisites:" >&2
  echo "  - Current branch must be pushed to origin" >&2
  echo "  - GitHub CLI (gh) must be installed" >&2
  echo "  - ~/confs/git/.users-list.conf must be configured" >&2
  echo "" >&2
  echo "Example from any repo:" >&2
  echo "  cd ~/my-project" >&2
  echo "  git checkout feature/my-branch" >&2
  echo "  git push -u origin HEAD" >&2
  echo "  bash ~/confs/.ai/scripts/gh-pr.command.sh" >&2
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

# Authenticate first (this script handles credentials securely)
echo "Authenticating with GitHub CLI..."
bash "$script_dir/gh-auth.command.sh"

echo ""
echo "Creating Pull Request..."

# Create PR using --fill to auto-populate from commits
gh pr create --fill

echo ""
echo "✅ Pull Request created successfully!"
