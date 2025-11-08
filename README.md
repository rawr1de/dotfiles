# Dotfiles Management Cheat Sheet

## Git Workflow for Dotfiles

### Daily Usage
```bash
# Check what files have changed
git status

# See the actual changes you made
git diff

# Stage specific files
git add bash/.bashrc
git add vim/.vimrc

# Stage all changed files
git add -A

# Commit with a message
git commit -m "Add new bash aliases"

# Push to GitHub
git push

# Pull latest changes from GitHub (on other machines)
git pull
```

### Common Scenarios
```bash
# Made changes on multiple machines? Pull first, then push
cd ~/dotfiles
git pull      # Get changes from other machines
git add -A
git commit -m "Update configs"
git push

# Undo unstaged changes to a file
git checkout -- bash/.bashrc

# View commit history
git log --oneline

# See what changed in last commit
git show
```

## Stow Directory Structure

Stow mirrors your home directory structure. Each subdirectory is a "package" you can stow independently.

```
~/dotfiles/
├── bash/
│   ├── .bashrc
│   ├── .bash_profile
│   └── .bash_aliases
├── vim/
│   └── .vimrc
├── git/
│   └── .gitconfig
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.vim
├── tmux/
│   └── .tmux.conf
├── ssh/
│   └── .ssh/
│       └── config
└── deploy.sh
```

### Structure Rules
- Files in `bash/` go to `~/`
- Files in `nvim/.config/nvim/` go to `~/.config/nvim/`
- The path inside the package mirrors where it goes in your home directory

### Stow Commands
```bash
# Stow a package (creates symlinks)
stow bash

# Stow with verbose output (see what it's doing)
stow -v bash

# Unstow a package (removes symlinks)
stow -D bash

# Restow a package (remove and recreate symlinks)
stow -R bash

# Stow multiple packages at once
stow bash vim git nvim

# Dry run (see what would happen without doing it)
stow -n -v bash
```

## Deployment on New Machine

### Prerequisites
```bash
# Debian/Ubuntu
sudo apt update && sudo apt install -y git stow

# Fedora/RHEL
sudo dnf install -y git stow

# macOS
brew install stow
```

### Quick Deploy
```bash
# One-liner deploy (if deploy.sh is in your repo)
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/deploy.sh | bash
```

### Manual Deploy
```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# 2. Navigate to dotfiles directory
cd ~/dotfiles

# 3. Stow the packages you want
stow bash
stow vim
stow git
stow nvim
stow tmux

# Or stow everything at once
stow */

# 4. Verify symlinks were created
ls -la ~ | grep '\->'

# 5. Source your new configs (or restart shell)
source ~/.bashrc
```

### Verify Installation
```bash
# Check if symlinks are correct
ls -la ~/.bashrc    # Should show -> ~/dotfiles/bash/.bashrc
ls -la ~/.vimrc     # Should show -> ~/dotfiles/vim/.vimrc

# Test your configs
vim --version
git --version
```

## Troubleshooting

### Stow Conflicts
```bash
# If stow says "existing target is not a symlink"
# You need to move or remove the existing file first
mv ~/.bashrc ~/.bashrc.backup
stow bash
```

### Update All Machines
```bash
# On machine 1: Make changes and push
cd ~/dotfiles
git add -A
git commit -m "Update configs"
git push

# On machine 2: Pull changes (symlinks update automatically)
cd ~/dotfiles
git pull
```

## Quick Reference

| Task | Command |
|------|---------|
| Add new config | Move file to dotfiles structure, `stow package`, `git add -A`, commit, push |
| Update existing config | Edit file (it's symlinked), commit, push |
| Deploy to new machine | Clone repo, `stow` packages |
| Sync between machines | `git pull` on other machines |
| Remove a config | `stow -D package`, delete from repo, commit, push |