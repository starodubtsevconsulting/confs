# Confs

A collection of setup scripts and configuration snippets for my machines.

This repo is meant to make fresh Ubuntu setups fast and repeatable. It includes
scripts for terminal setup (zsh, completions, prompt) and Git tooling, and will
grow to cover other tools and system configs over time.

This is for desktop machines, not servers. I keep it simple and prefer
predictable home-folder installs (e.g. `~/node/25`, `~/java/21-aws`) so scripts
always know where to look. It might not match how others do it, but it works
for me. I may add a server-focused repo later.

## Philosophy

This repo follows a simple workflow:
- `setup.sh`: install/setup everything in one run (or cherry-pick folder setups).
- `switch.sh`: switch between versions/users by repointing symlinks or updating local config.
- config scripts: additional small tweaks when needed.

For tools where I need multiple versions (e.g. Java, Python, Scala), I prefer
installing into the home folder and switching explicitly. I do not want a full
version manager stack for every language; I only need a few predictable wrapper
commands.

For tools where a single global install is enough (e.g. Git tooling, Docker), it
is OK to install system-wide.

Think of it as a lightweight “Nx-style” repo, but for installing and setting up
development tooling.

## Structure

This repo is organized into folders. Each folder has a `setup.sh` and a
README with details for that area.

## Usage

## How I use it

I clone this repo into my home folder (e.g. `~/confs`) so it is always easy to
find, then run everything from there.

Typical flow:
- `./check.sh`
- `./setup.sh`
- use per-folder `switch.sh` where available

I use this repo almost daily (installing/reinstalling, switching versions,
moving between laptop/desktop, testing other projects against different Python /
Java / Scala versions), so it is naturally kept up to date.

Maintenance is intentionally lightweight: I use AI, but it must follow the
workflow under `.ai/` (plan.md -> commit small steps -> PR comment -> merge on
request), which makes it easy to keep this repo consistent.

Before doing anything, run `./check.sh` to see what is already installed.

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

I typically stick to the latest Ubuntu LTS release, so `v_matrix.json` usually
contains only one Ubuntu codename. I do not run experimental Linux versions.
Sometimes installing the latest toolchains (e.g. Python) on a given distro can
be hard when the OS is too old (missing packages) or too new (ecosystem not
ready yet). The LTS release tends to be the sweet spot.
If you need support for another Ubuntu release, add your codename/version entry
to the matrix.

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

## Wrapping up

Feel free to contribute or fork; this repo is free to use.
If you have any other questions, visit my site: https://starodubtsev.consulting/
Blog: https://locusesse.com/
