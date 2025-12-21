# Confs

A collection of setup scripts and configuration snippets for my machines.

This repo is meant to make fresh Ubuntu setups fast and repeatable. It includes
scripts for terminal setup (zsh, completions, prompt) and Git tooling, and will
grow to cover other tools and system configs over time.

This is for desktop machines, not servers. I keep it simple and prefer
predictable home-folder installs (e.g. `~/node/25`, `~/java/21-aws`) so scripts
always know where to look. It might not match how others do it, but it works
for me. I may add a server-focused repo later.

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
You can stack it with `./setup.sh` to compare what you have vs what each setup
will install.
For language runtimes, `v_matrix.json` controls the recommended versions per
OS and whether the latest is installed alongside the selected one.

Some setup scripts may overlap and try to install already installed packages.
That is OK and intentional.

After running, open a new terminal (or run `exec zsh`) to activate the changes.

## AI helpers

This repo includes a lightweight AI agents setup under `.ai/`. If you use
Codex or any other AI agent, point it at `.ai/` so it can follow the rules and
use the command list to install items from the folders.
This, along with the folder structure and READMEs, should be enough context
for your AI companion to be helpful.

Note: the scripts are written for zsh/bash and should work on macOS too, but
I have not tested that.

Setup scripts may update `~/.profile` and `~/.zshrc` to adjust PATH defaults.
Where a `switch.sh` exists, it only repoints the `current` symlink.
