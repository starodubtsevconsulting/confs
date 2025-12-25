# merge.command.md

## See also
- `.ai/dev-workflow.md`
- `.ai/pr.command.md`
- `.ai/pr-post-step.command.md`

## Goal
Squash-merge a PR and keep all PR comments/discussion (GitHub keeps them automatically).

## Preconditions
- PR is approved (if required).
- CI checks are green.
- No merge conflicts.

## Merge (recommended: squash)

If you prefer a helper script, see `bash ./.ai/scripts/gh-merge.command.sh`.

### 1) Verify mergeability

```bash
gh pr view <PR_NUMBER> --json state,mergeable,mergeStateStatus,url
```

### 2) Squash-merge and delete remote branch

```bash
gh pr merge <PR_NUMBER> --squash --delete-branch
```

## Post-merge local cleanup

```bash
git checkout main
git fetch origin
git reset --hard origin/main
```

Optional: delete local branch

```bash
git branch -d <BRANCH_NAME>
```
