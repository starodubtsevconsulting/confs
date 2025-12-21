#!/usr/bin/env bash
set -euo pipefail

# Install GitHub CLI
sudo apt update
sudo apt install -y gh

echo "GitHub CLI installed. Run: gh auth login"
echo
echo "=== README ==="
cat "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/README.md"
