# pr.command.md

## See also
- `.ai/dev-workflow.md`
- `.ai/push.command.md`
- `.ai/merge.command.md`

## Goal
Create or update a GitHub Pull Request for the current feature branch.

## Prerequisites
- You already pushed your branch (see `.ai/push.command.md`).
- You are on the feature branch:

```bash
git branch --show-current
git status -sb
```

## Using GitHub CLI (recommended)

### 1) Authenticate
Run once per machine/session:

```bash
gh auth login
```

If you already use `./git/switch-user.sh` + `git/.users-list.conf` (with a PAT token), you can authenticate `gh` using the repo helper:

```bash
bash ./scripts/gh-auth.command.sh
```

If `git/.users-list.conf` has exactly one entry with a token, you can create the PR in one command:

```bash
bash ./scripts/gh-pr.command.sh
```

If you prefer non-interactive auth, set `GH_TOKEN` in your environment (do not commit it).

### 2) Create PR

```bash
gh pr create --fill
```

### 3) View PR / open in browser

```bash
gh pr view --web
```

### 4) Update PR after new commits
Just push again:

```bash
git push
```

## Required: PR comment
Before merging, add/update a descriptive PR comment based on `plan.md`:
- what changed
- why
- how to verify

## Without GitHub CLI (manual)
After pushing, GitHub prints a URL like:

```
https://github.com/<org>/<repo>/pull/new/<branch>
```

Open it, fill title/description.

## PR description
Per `.ai/dev-workflow.md` step 6:
- Use `plan.md` as source for the final descriptive comment.
- Do not commit `plan.md`.
