# dotfiles

Personal dotfiles for multiple machines — a **shared** base plus per-**host**
overlays, symlinked into `$HOME`.

```
shared/            linked on every host
  .config/nvim/    neovim config
  .gitconfig       git aliases, colors, identity
  .aliases         shell aliases
  .functions       shell functions
  .bash_prompt .inputrc .agignore
  .claude/settings.json   Claude Code prefs (host-agnostic)
hosts/
  laptop/          macOS workstation
    .bash_profile  brew / pyenv / iTerm2 / etc.
  pi/              home Raspberry Pi (berryfive)
    .claude/CLAUDE.md   Pi-specific global Claude context
.gitignore         also linked to ~/.gitignore (global git excludes)
install.sh         the linker
```

## Install

```bash
./install.sh          # or: make link
```

`install.sh` links everything in `shared/`, then the current host's overlay from
`hosts/<host>/`, mirroring paths into `$HOME`. The host is auto-detected
(`Darwin` → `laptop`, `Linux` → `pi`); override with `DOTFILES_HOST=laptop`.

Existing **real** files are backed up to `<file>.bak`; existing **symlinks** are
replaced in place. Re-running is safe and idempotent.

## Adding a machine

Create `hosts/<name>/` with only the files unique to that host, and (if it's not
Darwin/Linux-obvious) invoke with `DOTFILES_HOST=<name> ./install.sh`.
