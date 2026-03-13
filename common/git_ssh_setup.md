# Git / SSH Setup After Fresh Install

## 1. Generate a new SSH key
```bash
ssh-keygen -t ed25519 -C "your@email.com"
```
Press Enter twice to skip the passphrase.

## 2. Copy your public key
```bash
cat ~/.ssh/id_ed25519.pub
```

## 3. Add it to GitHub
GitHub → Settings → SSH and GPG keys → New SSH key → paste it in.

## 4. Switch git remote to SSH
```bash
git remote set-url origin git@github.com:rawr1de/dotfiles.git
```

## 5. Set your no-reply email and username
```bash
git config --global user.email "12345678+rawr1de@users.noreply.github.com"
git config --global user.name "rawr1de"
```

---

No passphrase, no prompts — push/pull works immediately.
Since the passphrase is skipped at generation (step 1), you never need to remove it later.

> `ed25519` is a modern elliptic curve signature algorithm — faster, more secure,
> and produces smaller keys than the older `rsa` algorithm.
