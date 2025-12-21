#!/usr/bin/env bash
set -euo pipefail

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

print_item() {
  local label="$1"
  local status="$2"
  local note="${3-}"
  local mark="[ ]"
  local tag="$status"

  case "$status" in
    OK)
      mark="[x]"
      tag="OK"
      ;;
    MISSING)
      mark="[ ]"
      tag="MISSING"
      ;;
    *)
      mark="[~]"
      tag="$status"
      ;;
  esac

  if [ -n "$note" ]; then
    printf "  %s %s - %s (%s)\n" "$mark" "$label" "$tag" "$note"
  else
    printf "  %s %s - %s\n" "$mark" "$label" "$tag"
  fi
}

echo "Terminal"
if has_cmd zsh; then
  print_item "zsh" "OK"
else
  print_item "zsh" "MISSING"
fi

zsh_path="$(command -v zsh || true)"
current_shell="$(getent passwd "$USER" | cut -d: -f7 || true)"
if [ -n "$zsh_path" ] && [ "$current_shell" = "$zsh_path" ]; then
  print_item "default shell" "OK"
else
  print_item "default shell" "NOT DEFAULT"
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  print_item "zsh autosuggestions" "OK"
else
  print_item "zsh autosuggestions" "MISSING"
fi

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  print_item "zsh syntax highlighting" "OK"
else
  print_item "zsh syntax highlighting" "MISSING"
fi

if has_cmd fzf; then
  print_item "fzf" "OK"
else
  print_item "fzf" "MISSING"
fi

if has_cmd bat || has_cmd batcat; then
  print_item "bat" "OK"
else
  print_item "bat" "MISSING"
fi

if has_cmd eza; then
  print_item "eza" "OK"
else
  print_item "eza" "MISSING"
fi

echo
echo "Git"
if has_cmd gh; then
  print_item "gh" "OK"
else
  print_item "gh" "MISSING"
fi

echo
echo "Vim"
if has_cmd vim; then
  print_item "vim" "OK"
else
  print_item "vim" "MISSING"
fi

if [ -f "$HOME/.vimrc" ]; then
  print_item "vimrc" "OK"
else
  print_item "vimrc" "MISSING"
fi

if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
  print_item "vim-plug" "OK"
else
  print_item "vim-plug" "MISSING"
fi

if [ -d "$HOME/.vim/plugged" ]; then
  print_item "plugins dir" "OK"
else
  print_item "plugins dir" "MISSING"
fi

echo
echo "Docker"
if has_cmd docker; then
  print_item "docker" "OK"
else
  print_item "docker" "MISSING"
fi

if has_cmd docker && docker compose version >/dev/null 2>&1; then
  print_item "docker compose plugin" "OK"
else
  print_item "docker compose plugin" "MISSING"
fi

if getent group docker >/dev/null 2>&1; then
  if id -nG "$USER" | grep -qw docker; then
    print_item "docker group" "OK"
  else
    print_item "docker group" "NOT ADDED"
  fi
else
  print_item "docker group" "MISSING"
fi

echo
echo "Python"
python_home="$HOME/python"
python_current="${python_home}/current/bin/python3"
pip_current="${python_home}/current/bin/pip3"

if [ -x "$python_current" ]; then
  python_version="$("$python_current" -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
  print_item "python3" "OK" "$python_version"
else
  if has_cmd python3; then
    print_item "python3" "SYSTEM"
  else
    print_item "python3" "MISSING"
  fi
fi

if [ -x "$pip_current" ]; then
  print_item "pip3" "OK" "home"
else
  if has_cmd pip3; then
    print_item "pip3" "SYSTEM"
  else
    print_item "pip3" "MISSING"
  fi
fi

if [ -x "$python_current" ] && "$python_current" -m venv --help >/dev/null 2>&1; then
  print_item "venv module" "OK"
else
  print_item "venv module" "MISSING"
fi

if [ -d "${python_home}/3.12" ]; then
  print_item "python 3.12 dir" "OK"
else
  print_item "python 3.12 dir" "MISSING"
fi

echo
echo "Java"
java_home="$HOME/java"
java_current="${java_home}/current/bin/java"
javac_current="${java_home}/current/bin/javac"

if [ -x "$java_current" ]; then
  java_major="$("$java_current" -version 2>&1 | head -n1 | sed -E 's/.*"([0-9]+).*/\\1/')"
  print_item "java" "OK" "${java_major:-unknown}"
else
  if has_cmd java; then
    print_item "java" "SYSTEM"
  else
    print_item "java" "MISSING"
  fi
fi

if [ -x "$javac_current" ]; then
  javac_major="$("$javac_current" -version 2>&1 | awk '{print $2}' | cut -d. -f1)"
  print_item "javac" "OK" "${javac_major:-unknown}"
else
  if has_cmd javac; then
    print_item "javac" "SYSTEM"
  else
    print_item "javac" "MISSING"
  fi
fi

if [ -d "${java_home}/21-aws" ]; then
  print_item "java 21 dir" "OK"
else
  print_item "java 21 dir" "MISSING"
fi

if [ -d "${java_home}/latest-aws" ]; then
  print_item "java latest dir" "OK"
else
  print_item "java latest dir" "MISSING"
fi
