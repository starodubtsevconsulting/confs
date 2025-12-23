# Add a new language/runtime

Use this checklist to add another language in the same style as Python/Java/Node/Scala.

1) Create a folder `<lang>/` with `setup.sh`, `switch.sh`, and `README.md`.
   - Follow existing setup patterns: home-local install (e.g., `~/lang`), `current` symlink, `~/bin/<lang>-switch`.
   - Install at least two versions: the matrix-selected/specific version and the latest available release (put the latter under a clear path like `~/lang/latest`).
   - Stage downloads/extracts in a temp dir; only move into `~/lang` after success. Validate URLs before fetching; fail fast with a clear message and suggest an override env var.
   - Track what you download and unpack (tarballs, temp dirs) and clean them explicitly. When cleaning the runtime home (`~/lang`), keep only numeric version dirs, `latest`, `current`, and `switch.sh`; don’t delete artifacts you created mid-run unless you know they’re stale.
   - Print the current inventory before installing and print the installed inventory afterward (include `latest` and resolved version strings).
   - After install, print a concise list of installed versions (including `latest`) with their resolved version strings.
   - End `setup.sh` by printing the local README.
2) Update `v_matrix.json` with defaults/recommended versions for the new language.
3) Update `check.sh` to report the new language (binary in `~/lang/current/bin`, version dir, switch.sh).
4) Add commands to `.ai/commands.md`:
   - Switch section: `<lang>-switch`
   - Setup section: `./<lang>/setup.sh`
5) If PATH blocks are needed, mirror the pattern used in existing `setup.sh` scripts (`~/.profile`, `~/.zshrc`).
6) Test: run `./check.sh`, then `./<lang>/setup.sh`, then `<lang>-switch` to verify the symlink switch.
