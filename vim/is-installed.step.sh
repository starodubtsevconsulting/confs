#!/usr/bin/env bash
set -euo pipefail

command -v vim >/dev/null 2>&1 && test -f "$HOME/.vimrc"
