# agentfiles

My portable AI tooling config, managed with [chezmoi](https://www.chezmoi.io/)
and synced across macOS, Windows, and WSL.

## What's in here

| Destination | Source |
|---|---|
| `~/.config/opencode/opencode.jsonc` | `dot_config/opencode/opencode.jsonc.tmpl` |
| `~/.config/opencode/AGENTS.md` | `dot_config/opencode/AGENTS.md` |
| `~/.config/opencode/agents/` | `dot_config/opencode/agents/` |
| `~/.agents/skills/` | `dot_agents/skills/` |

Secrets are **not** stored here. All API keys are resolved at runtime via
1Password `op://` references in `opencode.jsonc`, so this repo is safe to keep
private without leaking credentials.

## Machine-specific values

The only per-machine value is `pandiumMcpPath` — the absolute path to your local
`pandium-mcp` checkout. chezmoi prompts for it on `init` and stores it in the
machine-local `~/.config/chezmoi/chezmoi.toml` (never committed). It's injected
into `opencode.jsonc` via the `{{ .pandiumMcpPath }}` template variable.

## Onboarding a new machine

### 1. Install prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (`op`)
- [OpenCode](https://opencode.ai)
- Node.js (for `npx`-based MCP servers)
- A local checkout of `pandium-mcp` (note its absolute path)

### 2. Pull and apply

```sh
chezmoi init --apply git@github.com:<you>/agentfiles.git
```

chezmoi will prompt for `pandiumMcpPath`. Enter the absolute path with **forward
slashes**, e.g.:

- Windows: `C:/git/pandium-mcp`
- macOS:   `/Users/todd/git/pandium-mcp`
- WSL:     `/home/todd/git/pandium-mcp`

### 3. WSL note

Treat WSL as an independent Linux machine. Run `chezmoi init --apply` inside the
WSL home (`~`), **not** against a `/mnt/c/...` Windows path. Each environment
keeps its own `chezmoi.toml` with the correct `pandiumMcpPath`.

## Daily workflow

```sh
# Edit a managed file (opens the source, applies on save)
chezmoi edit ~/.config/opencode/opencode.jsonc

# Or edit the real file, then pull the change back into the source
chezmoi add ~/.config/opencode/opencode.jsonc

# See what would change
chezmoi diff

# Apply source -> home
chezmoi apply

# Push changes to the shared repo
chezmoi cd
git add -A && git commit -m "update opencode config" && git push
exit

# On another machine: pull latest and apply
chezmoi update
```
