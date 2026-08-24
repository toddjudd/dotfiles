# This file is managed by chezmoi (source: dotfiles repo). Edit it there and run
# `chezmoi apply`, not here. See the chezmoi source dir for related config.
op completion powershell | Out-String | Invoke-Expression
Invoke-Expression (&starship init powershell)
