#!/usr/bin/env bash
set -euo pipefail

NODE_MAJOR="22"
NODE_HOME="$HOME/node"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! "$script_dir/../scripts/confirm-reinstall.sh" "Node.js" "test -x \"$NODE_HOME/current/bin/node\""; then
  exit 0
fi

arch="$(uname -m)"
case "$arch" in
  x86_64)
    node_arch="x64"
    ;;
  aarch64|arm64)
    node_arch="arm64"
    ;;
  *)
    echo "Unsupported architecture: $arch"
    exit 1
    ;;
 esac

cleanup() {
  if [ -n "${WORKDIR:-}" ] && [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

WORKDIR="$(mktemp -d)"

# Find latest Node.js for the selected major
latest_version="$(python3 - "$NODE_MAJOR" <<'PY'
import json
import sys
import urllib.request

major = sys.argv[1]
with urllib.request.urlopen("https://nodejs.org/dist/index.json") as resp:
    data = json.load(resp)

for entry in data:
    ver = entry.get("version", "").lstrip("v")
    if ver.startswith(major + "."):
        print(ver)
        break
PY
)"

if [ -z "$latest_version" ]; then
  echo "Failed to detect latest Node.js ${NODE_MAJOR}.x version"
  exit 1
fi

tarball="node-v${latest_version}-linux-${node_arch}.tar.xz"
url="https://nodejs.org/dist/v${latest_version}/${tarball}"

mkdir -p "$NODE_HOME"
cd "$WORKDIR"

curl -fsSLO "$url"
tar -xJf "$tarball"

extracted_dir="node-v${latest_version}-linux-${node_arch}"
if [ ! -d "$extracted_dir" ]; then
  echo "Failed to extract Node.js"
  exit 1
fi

rm -rf "$NODE_HOME/${latest_version}"
mv "$extracted_dir" "$NODE_HOME/${latest_version}"

ln -sfn "$NODE_HOME/${latest_version}" "$NODE_HOME/current"
ln -sfn "$NODE_HOME/${latest_version}" "$NODE_HOME/${NODE_MAJOR}"

# Copy switch helper to home installs
cp "$script_dir/switch.sh" "$NODE_HOME/switch.sh"
chmod +x "$NODE_HOME/switch.sh"
cp "$script_dir/switch.sh" "$NODE_HOME/${latest_version}/switch.sh"
chmod +x "$NODE_HOME/${latest_version}/switch.sh"
cp "$script_dir/switch.sh" "$NODE_HOME/${NODE_MAJOR}/switch.sh"
chmod +x "$NODE_HOME/${NODE_MAJOR}/switch.sh"

profile="$HOME/.profile"
block_start="# NODE_HOME_START"
block_end="# NODE_HOME_END"

if ! grep -q "$block_start" "$profile" 2>/dev/null; then
  {
    echo ""
    echo "$block_start"
    echo "export NODE_HOME=\"$NODE_HOME\""
    echo "export PATH=\"\$NODE_HOME/current/bin:\$PATH\""
    echo "$block_end"
  } >> "$profile"
fi

echo "Node.js ${latest_version} installed in ${NODE_HOME}/${latest_version}"
echo
echo "=== README ==="
cat "$script_dir/README.md"
