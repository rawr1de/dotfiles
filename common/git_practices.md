Set the Default Push Behavior
By default, Git often tries to push your current branch to a branch with the same name on the remote. You can change this so that Git is "simpler" to use.
Run this to tell Git: "Always push to the branch I'm currently tracking":
git config --global push.default upstream

Link your Local Branches to main
Even if you are working on legion_local, you can tell Git that its "parent" or "upstream" is actually the main branch on GitHub (origin/main).
Run this while on your legion_local branch:
git branch --set-upstream-to=origin/main 

The "One-Command" Push to Main
If you want to stay on legion_local but send your finished work directly to the main branch on GitHub (without switching branches), use this command:
git push origin legion_local:main


set git default editor
git config --get core.editor "emacsclient -c --alternate-editor=''"
or
git config --get core.editor "nano"

show all configs
git config --list
filter editor chosen
git config --list | grep editor

git tree alias
alias.tree=log --graph --oneline --all --decorate


# Git Rebase Cheatsheet

alias gt="git log --graph --oneline --all --decorate"

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