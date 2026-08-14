# dotfiles

Todd's unified config — shell, editor/terminal, GUI apps, and AI tooling —
managed with [chezmoi](https://www.chezmoi.io/) and synced across macOS,
Windows, and WSL from a single source of truth.

> This repo supersedes the old symlink-based `dotfiles` layout and the
> experimental `agentfiles` repo. The pre-migration state is preserved on the
> `pre-chezmoi` tag for rollback.

## What's in here

| Destination | Source | OS |
|---|---|---|
| `~/.config/opencode/opencode.jsonc` | `dot_config/opencode/opencode.jsonc.tmpl` | all |
| `~/.config/opencode/AGENTS.md`, `agents/` | `dot_config/opencode/` | all |
| `~/.agents/skills/` | `dot_agents/skills/` | all |
| `~/.config/gh/config.yml` | `dot_config/gh/private_config.yml` | all |
| `~/.config/starship/starship.toml` | `dot_config/starship/` | all |
| `~/.config/wl/config` | `dot_config/wl/` | all |
| `~/.gitconfig` | `dot_gitconfig` | all |
| `~/.zshrc`, `~/.config/.zsh/` | `dot_zshrc.tmpl`, `dot_config/dot_zsh/` | mac + linux |
| `~/.bashrc` | `dot_bashrc.tmpl` | mac + linux |
| `~/.config/iterm2/`, `karabiner/` | `dot_config/` | mac |
| `~/.ssh/config` | `private_dot_ssh/config.tmpl` | mac (+ per-OS agent) |
| `~/.config/powershell/…` | `dot_config/powershell/` | windows |

Per-OS inclusion is enforced via `{{ .chezmoi.os }}` guards in `.chezmoiignore`
and templates.

### Secrets

No secrets are stored here. OpenCode API keys resolve at runtime via 1Password
`op://` references. `~/.config/gh/hosts.yml` (which gh writes with an
`oauth_token` at runtime) is listed in `.chezmoiignore` so it is **never**
managed or committed.

### SSH / 1Password

`~/.ssh/config` uses the 1Password SSH agent via a per-OS `IdentityAgent`:

- macOS: `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`
- Windows: `\\.\pipe\openssh-ssh-agent`
- WSL: `~/.1password/agent.sock` (forwarded from Windows via `npiperelay`)

## Machine-specific values

Prompted on `chezmoi init`, stored in the machine-local
`~/.config/chezmoi/chezmoi.toml` (never committed):

- `pandiumMcpPath` — absolute path (forward slashes) to your local
  `pandium-mcp` checkout. Injected into `opencode.jsonc`.
- `mcpPath` — optional `PATH` prepended into every MCP server `environment`.
  Needed on WSL for asdf shims, e.g.
  `/home/todd/.asdf/shims:/home/todd/.local/bin:/usr/local/bin:/usr/bin:/bin`.
  Leave blank on macOS/Windows.

## Onboarding a new machine

### 1. Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (`op`)
  + the 1Password desktop app with the SSH agent enabled
- [OpenCode](https://opencode.ai) and Node.js (for `npx` MCP servers)
- A local checkout of `pandium-mcp` (note its absolute path)

### 2. Pull and apply

This repo lives in a normal git directory, not the default hidden chezmoi
source dir. Use `--source`:

```sh
# Windows (from any shell)
chezmoi init --apply --source C:/git/dotfiles git@github.com:toddjudd/dotfiles.git

# macOS / WSL
chezmoi init --apply --source ~/git/dotfiles git@github.com:toddjudd/dotfiles.git
```

`sourceDir` is persisted automatically in the machine-local
`~/.config/chezmoi/chezmoi.toml`, so later commands find the repo without
`--source`.

### 3. WSL note

Treat WSL as an independent Linux machine. Run `chezmoi init --apply` inside the
WSL home (`~`), **not** against a `/mnt/c/...` Windows path. Seed `mcpPath` with
the asdf-shims PATH there, and confirm 1Password SSH-agent forwarding for pushes.

## Daily workflow

```sh
chezmoi edit ~/.config/opencode/opencode.jsonc   # edit source, applies on save
chezmoi add ~/.config/opencode/opencode.jsonc    # or pull a real edit back in
chezmoi diff                                      # preview
chezmoi apply                                     # source -> home
chezmoi cd && git add -A && git commit -m "…" && git push && exit
chezmoi update                                    # on another machine
```
