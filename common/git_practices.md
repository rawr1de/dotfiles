# Git Rebase Cheatsheet

## rebase

Replay your commits on top of another branch/commit,
keeping history linear.
(Local commits  diverged from remote.)

```bash
git pull --rebase
git rebase main
```

` `  ` `  ` `

### --continue
Resume a rebase after resolving conflicts or editing a commit.
```bash
git rebase --continue
```

` `  ` `  ` `

### --abort
Bail out and return to the state before the rebase started.
```bash
git rebase --abort
```

` `  ` `  ` `

## amend
Modify the last commit (message or content) before pushing.
```bash
git commit --amend
git commit --amend -m "new message"
```