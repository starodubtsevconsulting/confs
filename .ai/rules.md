# .ai rules

Purpose: keep Codex work consistent across this repo.

Core rules:
- Main entrypoint is `setup.sh` in each folder; extra helper scripts are OK.
- Every `setup.sh` must print its local README at the end on success.
- Root `setup.sh` may orchestrate multiple folders; it should stay interactive.
- `check.sh` is the first step to assess what is installed before changing anything.
- Reinstall requests are allowed; check current state first, then reapply only what is needed.
- Prefer targeted actions (cherry-pick) over full reruns when a specific tool is requested.

Repo structure:
- Each folder owns its setup, README, and optional helpers.
- Home-local installs are preferred when system installs are restricted.
- When adding new tooling, update `check.sh` to report it.
- For language runtimes, use `v_matrix.json` to pick recommended versions and
  install multiple majors when configured; provide a local `switch.sh`.

AI workflow expectations:
- Be explicit about what will change before running it.
- Keep changes minimal, avoid unrelated edits.
- Follow the repo conventions and update READMEs when behavior changes.
