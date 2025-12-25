# pr-post-step.command.md

## See also
- `.ai/dev-workflow.md`
- `.ai/merge.command.md`

## Goal
After a PR is merged: switch back to `main`, sync it to `origin/main`, and delete the merged branch.

## Recommended (use helper script)

```bash
bash ./scripts/pr-post-step.command.sh <branch-name>
```

Example:

```bash
bash ./scripts/pr-post-step.command.sh fix/dev-workflow-commit-immediately
```

## Manual steps (reference)

```bash
git checkout main
git fetch origin
git reset --hard origin/main

git branch -d <branch-name>
git push origin --delete <branch-name>
```

Notes:
- Branch deletion should happen after merge.
- Remote deletion may be optional if the PR merge deleted it.
