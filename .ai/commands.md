# .ai commands

Common actions for this repo:

```bash
# Check what is installed
./check.sh

# Switch language versions
python-switch
java-switch
scala-switch
node-switch

# Switch git user for this repo (no --global)
./git/switch-user.sh

# Run all setups from the root
./setup.sh

# Run a specific setup
./terminal/setup.sh
./git/setup.sh
./vim/setup.sh
./docker/setup.sh
./python/setup.sh
./java/setup.sh
./scala/setup.sh
./sbt/setup.sh
./nodejs/setup.sh
```

Notes:
- Run `./check.sh` first to decide whether to re-run a setup.
- Reinstalling is OK; setups are idempotent where possible.
- For adding a new language, follow `.ai/add-new.command.md`.
- When adding/updating a `*.command.md`, consider adding/updating a matching script in `.ai/scripts/`.

Script naming:
- `.ai/scripts/*.command.sh` is only for scripts that act as the backend for a `.ai/*.command.md` (meant to be run directly by you).
- `scripts/*.step.sh` is for helper steps used by other scripts/modules (not a command backend).
