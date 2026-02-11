# Repository Guidelines

## Security First (Most Important)
- Never commit secrets. Put machine- or secret-specific settings in local, untracked files (e.g., `~/.gitconfig.local`).
- Avoid hard-coded tokens, passwords, or private URLs in any tracked file. If in doubt, leave it out.

## Structure
- This is a topic-based dotfiles repo. Each top-level folder is a topic (`git/`, `zsh/`, `macos/`).
- `topic/*.zsh` loads automatically; `path.zsh` loads first; `completion.zsh` loads last.
- `topic/*.symlink` is symlinked into `$HOME` by `script/bootstrap`.
- `bin/` is added to `PATH`.
- `script/` contains setup helpers.

## Commands
- `script/bootstrap`: symlink dotfiles into `$HOME`.
- `script/install`: run per-topic `install.sh` scripts.
- `bin/dot`: apply defaults and install dependencies.

Example: `cd ~/.dotfiles && script/bootstrap`

## Style
- Follow existing patterns (`path.zsh`, `completion.zsh`, `*.symlink`).
- Match native config syntax (e.g., tabs in `git/gitconfig.symlink`).

## Testing
- No automated test suite. Validate by running relevant scripts and the tool you changed.

## Commits & PRs
- Keep commit messages short and descriptive (e.g., “update zshrc”).
- PRs: include a brief summary and the affected topics.
