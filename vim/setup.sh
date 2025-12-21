#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! "$script_dir/../scripts/confirm-reinstall.sh" "Vim" "command -v vim"; then
  exit 0
fi

# Install Vim and dependencies
sudo apt update
sudo apt install -y vim curl git

# Backup existing vimrc if present
if [ -f "$HOME/.vimrc" ]; then
  cp "$HOME/.vimrc" "$HOME/.vimrc.bak.$(date +%Y%m%d-%H%M%S)"
fi

# Install vim-plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Write .vimrc
cat <<'VIMRC' > "$HOME/.vimrc"
" ~/.vimrc

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
call plug#end()

set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamedplus
set termguicolors
set background=dark

colorscheme gruvbox

" Keep statusline simple (no special fonts required)
let g:airline_powerline_fonts = 0
VIMRC

# Install plugins (best effort)
if command -v vim >/dev/null 2>&1; then
  vim +PlugInstall +qall || true
fi

echo "Vim setup complete"
echo
echo "=== README ==="
cat "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/README.md"
