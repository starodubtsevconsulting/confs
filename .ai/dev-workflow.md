1. create a branch for the work
2. keep plan.md do not commit it (git ignore) and keep it up to date
3. update `.ai/*.md` if needed
4. before committing/pushing, switch/check repo-local git user (do NOT use `--global`) (see `.ai/commit.command.md` for identity setup):
   - `./git/switch-user.sh`
5. git commit every logical step with descriptive message (see `.ai/commit.command.md` for details)
6. git push (see `.ai/push.command.md` for details)
7. create PR (use data from plan.md for the final descriptive comment what was done in PR, see `.ai/pr.command.md` for details)