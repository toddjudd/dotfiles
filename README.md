# Dotfiles symlinked for personal setup

[Choco Setup Gist](https://gist.github.com/toddjudd/253df3e616c42a4d020ea7fd210c462c)

## Git aliases (cross-platform)

This repo includes shared Git aliases in `.gitconfig`.

Enable them on each machine with:

```bash
git config --global include.path "$HOME/git/dotfiles/.gitconfig"
```

```powershell
git config --global include.path "$env:USERPROFILE/git/dotfiles/.gitconfig"
```

After that, run:

```bash
git prenv
```
