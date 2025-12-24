#!/usr/bin/env bash
set -euo pipefail

section() {
  echo
  echo "== $1 =="
}

ok() {
  echo "OK: $1"
}

warn() {
  echo "WARN: $1" >&2
}

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

section "Docker post-setup checks"

if ! command -v docker >/dev/null 2>&1; then
  fail "docker CLI not found on PATH"
fi

ok "docker CLI found: $(command -v docker)"

if docker_version="$(docker --version 2>/dev/null)"; then
  ok "$docker_version"
else
  fail "docker --version failed"
fi

if systemctl is-enabled docker >/dev/null 2>&1; then
  ok "docker service is enabled"
else
  warn "docker service is not enabled"
fi

if systemctl is-active docker >/dev/null 2>&1; then
  ok "docker service is active"
else
  warn "docker service is not active"
fi

groups "$USER" | grep -q "\bdocker\b" && ok "user '$USER' is in docker group" || warn "user '$USER' is NOT in docker group (log out/in after install to use docker without sudo)"
