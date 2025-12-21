#!/usr/bin/env bash
set -euo pipefail

NODE_HOME="$HOME/node"

if [ -z "${1-}" ]; then
  echo "Usage: $0 <version|major>"
  echo "Example: $0 22 or $0 22.12.0"
  exit 2
fi

target="$1"
if [ ! -d "$NODE_HOME/$target" ]; then
  echo "Not found: $NODE_HOME/$target"
  exit 1
fi

ln -sfn "$NODE_HOME/$target" "$NODE_HOME/current"

echo "Now using: $NODE_HOME/current"
echo "If needed, reload shell or run: source ~/.profile"
