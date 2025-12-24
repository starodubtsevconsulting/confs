# Add a new language/runtime

Use this checklist to add another language in the same style as Python/Java/Node/Scala.

1) Naming convention:
   - `setup.sh` is the main entrypoint.
   - `switch.sh` is the only other allowed `*.sh` in a module.
   - Any additional helper scripts should use `*.step.sh` (e.g. `post-setup.step.sh`, `report.step.sh`).

2) Create a folder `<lang>/` with `setup.sh`, `switch.sh`, `post-setup.step.sh`, and `README.md`.
   - Follow existing setup patterns: home-local install (e.g., `~/lang`), `current` symlink, `~/bin/<lang>-switch`.
   - Every executable script should append a short OK/FAIL line to `report.log` (this file is gitignored).
     Use `scripts/report.step.sh` and call `report_log_init "<label>" "$root_dir"`.
   - If you need an `apt update` in `setup.sh`, use the repo wrapper (currently `scripts/apt-update.sh`) instead of raw `sudo apt update`.
     This gives a clearer error when the system has a broken apt source after an OS upgrade. Optionally, users can set
     `CONFS_AUTO_DISABLE_BROKEN_APT_SOURCES=1` to auto-disable sources that fail with "does not have a Release file".
   - Always add a `post-setup.step.sh` that verifies what `setup.sh` installed (binaries on PATH, expected dirs/symlinks, versions).
     End `setup.sh` by running `bash "$script_dir/post-setup.step.sh"` so failures are caught immediately.
   - Install at least two versions: the matrix-selected/specific version and the latest available release (put the latter under a clear path like `~/lang/latest`).
   - Stage downloads/extracts in a temp dir; only move into `~/lang` after success. Validate URLs before fetching; fail fast with a clear message and suggest an override env var.
   - Track what you download and unpack (tarballs, temp dirs) and clean them explicitly. When cleaning the runtime home (`~/lang`), keep only numeric version dirs, `latest`, `current`, and `switch.sh`; don’t delete artifacts you created mid-run unless you know they’re stale.
   - Print the current inventory before installing and print the installed inventory afterward (include `latest` and resolved version strings).
   - After install, print a concise list of installed versions (including `latest`) with their resolved version strings.
3) Update `v_matrix.json` with defaults/recommended versions for the new language.
4) Update `check.sh` to report the new language (binary in `~/lang/current/bin`, version dir, switch script).
5) Add commands to `.ai/commands.md`:
   - Switch section: `<lang>-switch`
   - Setup section: `./<lang>/setup.sh`
6) If PATH blocks are needed, mirror the pattern used in existing `setup.sh` scripts (`~/.profile`, `~/.zshrc`).
7) Test: run `./check.sh`, then `./<lang>/setup.sh`, then `<lang>-switch` to verify the symlink switch.
