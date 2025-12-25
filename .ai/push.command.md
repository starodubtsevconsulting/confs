# push.command.md

## See also
- `.ai/dev-workflow.md`
- `.ai/commit.command.md`

## Rules / nuances
- Push feature branches, not `main`.
- Ensure repo-local git identity is correct before pushing.
- Use PRs for merging; prefer `gh` if available.

## Push checklist
1) Verify branch and status:

```bash
git branch --show-current
git status -sb
```

2) Push the current branch:

- First push (sets upstream):

```bash
git push -u origin HEAD
```

- Subsequent pushes:

```bash
git push
```

## PR creation (recommended)
Per `.ai/dev-workflow.md` step 6, create a PR and use `plan.md` as source for the final descriptive comment.

```bash
# Authenticate once per machine
# gh auth login

gh pr create --fill
# or if PR already exists:
# gh pr view --web
```

## If you accidentally committed on `main`
Preferred recovery:
- Create a branch at the current commit and push it.
- Then reset local `main` back to `origin/main`.

```bash
git branch <new-branch-name>
git push -u origin <new-branch-name>
git reset --hard origin/main
```
