0. always confirm you are NOT on `main` before doing any work:
   - `git branch --show-current`
   - why: committing on `main` makes it diverge from `origin/main` and can break automation (e.g. merge tooling may fail to fast-forward).
   - if you accidentally committed on `main`: extract those commit(s) onto a feature branch and reset local `main` to match `origin/main` (so `main` has NO extra commits).

1. create a branch for the work
   - naming: `feature/<name>`, `fix/<name>`, or `refactoring/<name>` (use kebab-case)
2. create and maintain plan.md (do not commit it; it is gitignored)
   - at the start of new work: reset it (e.g. `cp .ai/plan.md.template plan.md`) so it reflects only the current task
   - plan.md is the working checklist for the task (checkboxes): what we do, what is done, what is left
   - use plan.md as the source for PR comments / final report (what changed, why, how to verify)
3. update `.ai/*.md` if needed
   - rule: if you change `dev-workflow.md`, consider updating the relevant `*.command.md`.
   - rule: if you add/update a `*.command.md`, consider adding/updating a backend helper `.ai/scripts/*.command.sh` to automate it.
4. before committing/pushing, switch/check git user identity (see `.ai/commit.command.md` for identity setup):
   - `./git/switch-user.sh` - manages global Git profiles with switch/show/add/delete operations
5. git commit every logical step immediately (do not wait / do not batch unrelated work) with a descriptive message (see `.ai/commit.command.md` for details)
6. git push (see `.ai/push.command.md` for details)
7. create PR (use data from plan.md for the final descriptive comment what was done in PR, see `.ai/pr.command.md` for details)
8. before merging: add/update a descriptive PR comment (based on plan.md) so reviewers see what changed and how to verify
9. do not merge PRs automatically; only merge when explicitly asked
10. after PR is merged: delete the branch and switch back to `main` (synced to `origin/main`) (see `.ai/pr-post-step.command.md`)
