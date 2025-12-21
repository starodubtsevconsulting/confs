#!/usr/bin/env bash
set -euo pipefail

JAVA_HOME_BASE="$HOME/java"

cleanup() {
  if [ -n "${WORKDIR:-}" ] && [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

WORKDIR="$(mktemp -d)"

arch="$(uname -m)"
case "$arch" in
  x86_64)
    corretto_arch="x64"
    ;;
  aarch64|arm64)
    corretto_arch="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $arch"
    exit 1
    ;;
esac

corretto_url() {
  local major="$1"
  echo "https://corretto.aws/downloads/latest/amazon-corretto-${major}-${corretto_arch}-linux-jdk.tar.gz"
}

install_corretto_major() {
  local major="$1"
  local target_dir="$2"
  local url
  url="$(corretto_url "$major")"

  cd "$WORKDIR"
  curl -fsSLO "$url"
  tarball="amazon-corretto-${major}-${corretto_arch}-linux-jdk.tar.gz"
  tar -xzf "$tarball"

  extracted_dir="$(tar -tzf "$tarball" | head -n1 | cut -d/ -f1)"
  if [ -z "$extracted_dir" ] || [ ! -d "$extracted_dir" ]; then
    echo "Failed to extract Corretto $major"
    exit 1
  fi

  mkdir -p "$JAVA_HOME_BASE"
  rm -rf "$target_dir"
  mv "$extracted_dir" "$target_dir"
  rm -f "$tarball"
}

find_latest_major() {
  local candidates="25 24 23 22 21 20 19 18 17"
  local major
  for major in $candidates; do
    if curl -fsI "$(corretto_url "$major")" >/dev/null 2>&1; then
      echo "$major"
      return 0
    fi
  done
  return 1
}

latest_major="$(find_latest_major)"
if [ -z "$latest_major" ]; then
  echo "Failed to detect latest Corretto major version"
  exit 1
fi

install_corretto_major "21" "${JAVA_HOME_BASE}/21-aws"
if [ "$latest_major" = "21" ]; then
  ln -sfn "${JAVA_HOME_BASE}/21-aws" "${JAVA_HOME_BASE}/latest-aws"
else
  install_corretto_major "$latest_major" "${JAVA_HOME_BASE}/latest-aws"
fi

ln -sfn "${JAVA_HOME_BASE}/latest-aws" "${JAVA_HOME_BASE}/current"

profile="$HOME/.profile"
block_start="# JAVA_HOME_START"
block_end="# JAVA_HOME_END"

if ! grep -q "$block_start" "$profile" 2>/dev/null; then
  {
    echo ""
    echo "$block_start"
    echo "export JAVA_HOME=\"$JAVA_HOME_BASE/current\""
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
    echo "$block_end"
  } >> "$profile"
fi

echo "Java installed in ${JAVA_HOME_BASE}/21-aws and ${JAVA_HOME_BASE}/latest-aws"
echo
echo "=== README ==="
cat "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/README.md"
