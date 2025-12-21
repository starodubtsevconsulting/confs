# Confs

A collection of setup scripts and configuration snippets for my machines.

This repo is meant to make fresh Ubuntu setups fast and repeatable. It includes
scripts for terminal setup (zsh, completions, prompt) and Git tooling, and will
grow to cover other tools and system configs over time.

## Structure

- `terminal/` - shell and terminal setup scripts (zsh, prompt, completions)
- `git/` - Git tooling setup (GitHub CLI)

## Usage

Run the setup script you want, for example:

```bash
./setup.sh
./terminal/setup.sh
./git/setup.sh
```

After running, open a new terminal (or run `exec zsh`) to activate the changes.
