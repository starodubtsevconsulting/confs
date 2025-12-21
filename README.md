# Confs

A collection of setup scripts and configuration snippets for my machines.

This repo is meant to make fresh Ubuntu setups fast and repeatable. It includes
scripts for terminal setup (zsh, completions, prompt) and Git tooling, and will
grow to cover other tools and system configs over time.

## Structure

This repo is organized into folders. Each folder has a `setup.sh` and a
README with details for that area.

## Usage

Run the root setup script:

```bash
./setup.sh
```
Tip: run `./check.sh` first to see what is already installed before deciding
which folders to run.

Some setup scripts may overlap and try to install already installed packages.
That is OK and intentional.

After running, open a new terminal (or run `exec zsh`) to activate the changes.
