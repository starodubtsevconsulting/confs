#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! "$script_dir/../scripts/confirm-reinstall.sh" "GitHub CLI" "command -v gh"; then
  exit 0
fi

# Install GitHub CLI
sudo apt update
sudo apt install -y gh

echo "GitHub CLI installed. Run: gh auth login"
echo
echo "=== README ==="
cat "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/README.md"
