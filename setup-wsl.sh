#!/usr/bin/env bash
# WSL-specific dotfile symlink setup
# Run this from WSL: bash ~/dotfiles/setup-wsl.sh

DOTFILES="$HOME/dotfiles"

# Clone if not already present
if [ ! -d "$DOTFILES" ]; then
  echo "Cloning dotfiles..."
  git clone git@github.com:toddjudd/dotfiles.git "$DOTFILES"
fi

echo "Setting up dotfile symlinks for WSL..."

# Root-level dotfiles
for f in .gitconfig .gitignore .zshrc; do
  if [ -f "$DOTFILES/$f" ]; then
    ln -sfn "$DOTFILES/$f" "$HOME/$f"
    echo "  linked: ~/$f"
  fi
done

# .ssh/config (symlink is fine - native WSL path)
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ -f "$DOTFILES/.ssh/config" ]; then
  ln -sfn "$DOTFILES/.ssh/config" "$HOME/.ssh/config"
  # Use ed25519 key (generated in WSL) instead of id_rsa
  sed -i 's/id_rsa/id_ed25519/' "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  echo "  linked: ~/.ssh/config"
fi

# starship (symlink is fine - native WSL path)
mkdir -p "$HOME/.config/starship"
if [ -f "$DOTFILES/.config/starship/starship.toml" ]; then
  ln -sfn "$DOTFILES/.config/starship/starship.toml" "$HOME/.config/starship/starship.toml"
  echo "  linked: ~/.config/starship/starship.toml"
fi

# gh cli
mkdir -p "$HOME/.config/gh"
for f in config.yml hosts.yml; do
  if [ -f "$DOTFILES/.config/gh/$f" ]; then
    ln -sfn "$DOTFILES/.config/gh/$f" "$HOME/.config/gh/$f"
    echo "  linked: ~/.config/gh/$f"
  fi
done

echo "Done! Verify with: ls -la ~/ && ls -la ~/.config/"
