# commit.command.md

## See also
- `.ai/dev-workflow.md`
- `./git/switch-user.sh`

## Rules / nuances
- **Do not commit on `main`.** Create/switch to a feature branch first.
- **Do not commit `plan.md`.** Keep it gitignored.
- **Use repo-local git identity** (do not use `git config --global`).

## Commit checklist
1) Make sure you are on a feature branch:

```bash
git branch --show-current
```

2) Ensure the working tree is what you expect:

```bash
git status -sb
```

3) Switch/check repo-local git user before committing (per `.ai/dev-workflow.md`):

```bash
./git/switch-user.sh

git config user.name
git config user.email
```

4) Stage changes intentionally:

```bash
git add -A
# or stage specific files:
# git add path/to/file
```

5) Commit one logical step at a time:

```bash
git commit -m "<short summary>" -m "<details>"
```

## Message guidance
- Subject: imperative, short.
- Body: what changed + why.

Example:

```
Centralize install checks under scripts/is-installed

- Add scripts/is-installed.step.sh helper
- Use scripts/is-installed.common.step.sh for generic modules
- Keep module-local is-installed.step.sh only for special cases (e.g. scala)
```
