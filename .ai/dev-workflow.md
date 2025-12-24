1. create a branch for the work
2. update `.ai/*.md` if needed
3. before committing/pushing, switch/check repo-local git user (do NOT use `--global`):
   - `./git/switch-user.sh`
   - `git config user.name`
   - `git config user.email`
   - `git remote -v`
4. git commit every logical step with descriptive message
5. git push