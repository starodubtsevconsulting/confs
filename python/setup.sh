#!/usr/bin/env bash
set -euo pipefail

PYTHON_SERIES="3.12"
PYTHON_HOME="$HOME/python"

cleanup() {
  if [ -n "${WORKDIR:-}" ] && [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

WORKDIR="$(mktemp -d)"

# Build dependencies for Python from source
sudo apt update
sudo apt install -y \
  build-essential \
  ca-certificates \
  curl \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  tk-dev \
  uuid-dev \
  xz-utils \
  zlib1g-dev

latest_version="$(curl -fsSL https://www.python.org/ftp/python/ | \
  grep -oE "${PYTHON_SERIES}\\.([0-9]+)" | sort -V | tail -n1)"

if [ -z "$latest_version" ]; then
  echo "Failed to detect latest Python ${PYTHON_SERIES}.x version"
  exit 1
fi

tarball="Python-${latest_version}.tgz"
url="https://www.python.org/ftp/python/${latest_version}/${tarball}"

mkdir -p "$PYTHON_HOME"
cd "$WORKDIR"
curl -fsSLO "$url"
tar -xzf "$tarball"

cd "Python-${latest_version}"
./configure --prefix="${PYTHON_HOME}/${latest_version}" --enable-optimizations
make -j"$(nproc)"
make install

ln -sfn "${PYTHON_HOME}/${latest_version}" "${PYTHON_HOME}/current"
ln -sfn "${PYTHON_HOME}/${latest_version}" "${PYTHON_HOME}/${PYTHON_SERIES}"

"${PYTHON_HOME}/current/bin/python3" -m ensurepip --upgrade

profile="$HOME/.profile"
block_start="# PYTHON_HOME_START"
block_end="# PYTHON_HOME_END"

if ! grep -q "$block_start" "$profile" 2>/dev/null; then
  {
    echo ""
    echo "$block_start"
    echo "export PYTHON_HOME=\"$PYTHON_HOME\""
    echo "export PATH=\"\$PYTHON_HOME/current/bin:\$PATH\""
    echo "$block_end"
  } >> "$profile"
fi

echo "Python ${latest_version} installed in ${PYTHON_HOME}/${latest_version}"
echo
echo "=== README ==="
cat "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/README.md"
