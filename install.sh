#!/usr/bin/env bash
# Symlink dotfiles into $HOME: everything in shared/ on every host, then the
# current host's overlay from hosts/<host>/. Paths mirror $HOME (e.g.
# shared/.config/nvim/init.vim -> ~/.config/nvim/init.vim).
#
# Host is auto-detected (Darwin=laptop, Linux=pi); override with DOTFILES_HOST.
# Existing real files are backed up to <file>.bak; existing symlinks are replaced.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HOST="${DOTFILES_HOST:-}"
if [ -z "$HOST" ]; then
  case "$(uname -s)" in
    Darwin) HOST=laptop ;;
    Linux)  HOST=pi ;;
    *)      HOST=laptop ;;
  esac
fi
echo "dotfiles: $DOTFILES"
echo "host:     $HOST"
echo

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    ln -sfn "$src" "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "  backed up ${dest/#$HOME/\~} -> ${dest/#$HOME/\~}.bak"
    ln -s "$src" "$dest"
  else
    ln -s "$src" "$dest"
  fi
  echo "  ${dest/#$HOME/\~} -> ${src/#$DOTFILES/.}"
}

# Link every file under a tree into $HOME at its mirrored path.
link_tree() {
  local base="$1" f rel
  [ -d "$base" ] || return 0
  while IFS= read -r -d '' f; do
    rel="${f#"$base"/}"
    link "$f" "$HOME/$rel"
  done < <(find "$base" -type f -print0)
}

link_tree "$DOTFILES/shared"
link_tree "$DOTFILES/hosts/$HOST"

# Global git excludes file lives at the repo root (referenced by .gitconfig).
link "$DOTFILES/.gitignore" "$HOME/.gitignore"

echo
echo "done."
