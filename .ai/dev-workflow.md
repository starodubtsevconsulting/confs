0. always confirm you are NOT on `main` before doing any work:
   - `git branch --show-current`
   - why: committing on `main` makes it diverge from `origin/main` and can break automation (e.g. merge tooling may fail to fast-forward).
   - if you accidentally committed on `main`: extract those commit(s) onto a feature branch and reset local `main` to match `origin/main` (so `main` has NO extra commits).

1. create a branch for the work
2. keep plan.md do not commit it (git ignore) and keep it up to date
3. update `.ai/*.md` if needed
   - rule: if you change `dev-workflow.md`, consider updating the relevant `*.command.md`.
   - rule: if you add/update a `*.command.md`, consider adding/updating a helper `scripts/*.step.sh` to automate it.
4. before committing/pushing, switch/check repo-local git user (do NOT use `--global`) (see `.ai/commit.command.md` for identity setup):
   - `./git/switch-user.sh`
5. git commit every logical step immediately (do not wait / do not batch unrelated work) with a descriptive message (see `.ai/commit.command.md` for details)
6. git push (see `.ai/push.command.md` for details)
7. create PR (use data from plan.md for the final descriptive comment what was done in PR, see `.ai/pr.command.md` for details)
8. before merging: add/update a descriptive PR comment (based on plan.md) so reviewers see what changed and how to verify
