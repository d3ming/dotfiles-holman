# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a topic-based dotfiles repository for managing macOS/Unix shell configuration, based on Holman's dotfiles architecture. Each top-level directory represents a configuration "topic" (git, zsh, ruby, system, etc.) containing related configuration files, scripts, and aliases.

## Core Architecture

### File Type Convention

The repository uses file extensions and naming patterns to determine how files are processed:

- **`topic/*.zsh`**: Auto-loaded into shell environment
  - **`topic/path.zsh`**: Loaded FIRST (sets up `$PATH`)
  - **`topic/completion.zsh`**: Loaded LAST (sets up autocompletion)
  - All other `*.zsh` files: Loaded in between
- **`topic/*.symlink`**: Symlinked to `$HOME/.filename` (without the `.symlink` extension)
- **`topic/install.sh`**: Executed when running `script/install` (`.sh` extension prevents auto-loading)
- **`bin/*`**: Added to `$PATH` globally
- **`functions/*`**: ZSH completion functions

### Bootstrap Flow

1. `script/bootstrap` - Initial setup:
   - Creates `git/gitconfig.local.symlink` from template (if missing)
   - Symlinks all `*.symlink` files to `$HOME`
   - On macOS: runs `bin/dot` for dependencies

2. `bin/dot` - Maintenance/updates:
   - Sets macOS defaults via `macos/set-defaults.sh`
   - Installs Homebrew
   - Runs `script/install` to execute all topic `install.sh` scripts

3. `zsh/zshrc.symlink` - Shell initialization:
   - Loads `~/.localrc` for secrets/machine-specific config
   - Sources all `path.zsh` files first
   - Sources all other `*.zsh` files (except completion)
   - Initializes ZSH completion system
   - Sources all `completion.zsh` files last

## Key Commands

### Setup & Installation
```bash
# Initial setup (first time only)
cd ~/.dotfiles && script/bootstrap

# Run topic install scripts
script/install

# Update dependencies and apply macOS defaults
bin/dot

# Edit dotfiles in your $EDITOR
dot --edit
```

### No Test Suite
There are no automated tests. Validate changes by:
- Running the affected script/command manually
- Reloading your shell: `reload!` or `. ~/.zshrc`
- Testing the specific tool/alias you modified

## Configuration Patterns

### Adding Machine-Specific or Secret Configuration

**NEVER commit secrets.** Use local, untracked files:

- **`~/.localrc`**: Sourced by `zsh/zshrc.symlink` for env vars, secrets, machine-specific config
- **`~/.gitconfig.local`**: Included by `git/gitconfig.symlink` for git user info, credentials
- These files are `.gitignore`d and won't be tracked

### Adding a New Topic

1. Create directory: `mkdir newtopic`
2. Add configuration files:
   - `newtopic/path.zsh` - PATH modifications (loaded first)
   - `newtopic/aliases.zsh` - Shell aliases
   - `newtopic/completion.zsh` - Completions (loaded last)
   - `newtopic/config.symlink` - Config to symlink to `~/.config`
   - `newtopic/install.sh` - Installation script
3. Files are auto-discovered and loaded on next shell start

### Git Configuration

The git setup uses a split configuration:
- **`git/gitconfig.symlink`**: Public config (aliases, settings, colors)
- **`git/gitconfig.local.symlink`**: Private config (user name, email, credentials)
  - Generated from `gitconfig.local.symlink.example` during `script/bootstrap`
  - Never committed to repo

## Important Custom Tools

### Custom Git Commands (in `bin/`)
- `git-promote`: Promotes local branch to remote tracking
- `git-rank-contributors`: Shows contributor stats
- `git-delete-local-merged`: Cleans up merged branches
- `git-copy-branch-name`: Copies current branch to clipboard
- `git-nuke`: Hard reset and clean
- `git-edit-new`: Opens changed files in editor

### Shell Functions
- `c`: Quick navigation to projects in `$PROJECTS` (default: `~/projects`)
- `extract`: Universal archive extractor (tar, zip, rar, etc.)
- Defined in `functions/` directory

## Development Workflow

### Modifying Configuration

1. Edit the relevant topic file (e.g., `git/aliases.zsh`, `zsh/config.zsh`)
2. Reload shell: `reload!` or `. ~/.zshrc`
3. Test the changes
4. Commit with descriptive message: `git commit -m "update git aliases"`

### Working with Symlinks

- Symlinks point from `$HOME` back to `.dotfiles`
- Edit files in `.dotfiles` directory, not in `$HOME`
- To add new symlink: create `topic/filename.symlink`, then run `script/bootstrap`

### Formatting & Style

- **Git config files**: Use TABS for indentation (see `git/gitconfig.symlink`)
- **Shell scripts**: Follow existing style in each topic
- **Commit messages**: Short, descriptive, lowercase (e.g., "update zshrc", "add docker aliases")

## Dependencies

- **macOS-specific**: Some scripts assume macOS (homebrew, defaults, osxkeychain)
- **Homebrew**: Managed via `homebrew/install.sh`
- **rbenv**: Ruby version management (initialized in `zsh/zshrc.symlink`)
- **delta**: Git diff pager (configured in `git/gitconfig.symlink`)
- **hub**: Git wrapper for GitHub (aliased to `git` if available)

## Environment Variables

Set in `zsh/zshrc.symlink`:
- `$ZSH`: Points to `~/.dotfiles`
- `$PROJECTS`: Points to `~/projects` (used by `c` function for quick navigation)
- `$EDITOR`: Inherited from system or set in `system/env.zsh`
