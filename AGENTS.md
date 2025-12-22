## Overview

This is a Windows dotfiles repository that uses a bare Git repository pattern to track configuration files directly in the user profile directory (`$env:userprofile`). The repository is designed to manage dotfiles on Windows while respecting both Windows conventions (AppData) and Unix conventions (XDG Base Directory).

## Core Architecture: The `sw` (sync-windows) Pattern

**Critical Understanding:** This repository does NOT use traditional symlinks. Instead, it leverages Git's `--git-dir` and `--work-tree` flags to manage files in place.

```powershell
# The sw alias is defined in Documents/Powershell/Profile.ps1
sw <git-command>  # Equivalent to: git --git-dir=$env:userprofile/sync-windows/ --work-tree=$env:userprofile <git-command>
```

**Work tree:** `$env:userprofile` (the user's home directory)
**Git directory:** `$env:userprofile/sync-windows/` (this repository's .git location)

This means:
- Files are tracked in their original locations (no symlinks needed)
- Use `sw` instead of `git` for all operations when managing dotfiles
- The `.gitignore` excludes most Windows user directories (Desktop, Downloads, etc.) to only track config files

## Common Commands

### Dotfile Management (Use `sw` not `git`)
```powershell
# Check status of tracked dotfiles
sw status

# Add a configuration file
sw add .config/starship.toml

# Commit changes
sw commit -m "update: starship prompt configuration"

# Push to remote
sw push

# View diff
sw diff
```

### Package Management
```powershell
# Update all Scoop packages (cleans cache too)
scoop-ultimate

# Update all Winget packages
winget-ultimate

# Update everything (Scoop + Winget) and create backup
windows-ultimate

# Backup current package lists to backup/ directory
windows-backup
```

### Development Environment
```powershell
# Enter nix development shell (auto-loads via direnv)
nix develop

# Format Nix code
nix fmt

# Launch MSYS2 with fish shell
msys
```

### Formatting
```nix
# Format Nix files using treefmt (alejandra, deadnix, statix)
nix fmt
```

## Repository Structure

### Configuration Locations

**`.config/`** - XDG-compliant configs (Unix convention on Windows)
- `git/` - Git global config and ignore patterns
- `starship.toml` - Shell prompt configuration
- `wezterm/` - Terminal emulator (Lua config)
- `tridactyl/` - Firefox vim bindings
- `fastfetch/` - System info display
- `whkdrc` - Window hotkey daemon for window management

**`Documents/Powershell/`** - PowerShell configuration
- `Profile.ps1` - Shell initialization, aliases, and the critical `sw` function
- `powershell.config.json` - Execution policy config

**`AppData/`** - Windows application data (mirrors Windows structure)
- `Roaming/Mozilla/Firefox/` - Firefox profile with extensive privacy hardening
- `Roaming/kanata/` - Keyboard remapping (legacy)

**`backup/`** - Package manager snapshots
- `scoop_backup.txt` - Installed Scoop packages
- `winget_backup.txt` - Installed Winget packages
- `msys_pacman.txt` - MSYS2 packages

### Development Files
- `flake.nix` - Nix development environment definition
- `flake.lock` - Locked dependency versions
- `.envrc` - Direnv integration for auto-loading Nix shell
- `.editorconfig` - Editor settings (UTF-8, LF line endings, 2-space indent)

## Key Patterns & Conventions

### Git Commit Messages
Uses conventional commits pattern observed in recent history:
- `chore(component):` - Maintenance tasks
- `fix(component):` - Bug fixes
- `feat(component):` - New features
- `refactor(component):` - Code restructuring

Common components: `nix`, `ignore`, `pwsh`, `scoop`, `whkd`

### Adding New Configurations

When adding new dotfiles:

1. Place config files in appropriate locations:
   - Cross-platform tools → `.config/`
   - PowerShell scripts → `Documents/Powershell/`
   - Windows apps → `AppData/Roaming/` or `AppData/Local/`

2. Track with `sw add <path>` (NOT `git add`)

3. Update `.gitignore` if excluding new user data directories

4. If adding new tools, update package backups:
   ```powershell
   windows-backup
   ```

### Working with PowerShell Profile

The `Documents/Powershell/Profile.ps1` file is critical infrastructure:
- Defines the `sw` alias (DO NOT BREAK THIS)
- Sets environment variables (PATH, EDITOR, VISUAL, SHELL)
- Provides package management shortcuts
- Runs fastfetch and starship on shell startup

When modifying, preserve the `Invoke-GitWithCustomPaths` function integrity.

## Tool Ecosystem

**Package Managers:**
- Scoop - Primary package manager (port-based, scoop-ultimate updates all)
- Winget - Windows Package Manager (winget-ultimate updates all)
- MSYS2 - Unix-like environment with Pacman (launch with `msys`)

**Key Applications:**
- Terminal: Wezterm (Lua config in `.config/wezterm/`)
- Editor: Neovim (via `vim.exe` from Scoop)
- Shell: PowerShell 7.x with Starship prompt
- Browser: Firefox with privacy hardening and Tridactyl vim bindings
- Version Control: Git 2.52+

## Nix Integration

This repository includes Nix flake configuration for reproducible development:

**Flake modules:**
- `treefmt-nix` - Code formatting (alejandra, deadnix, statix for Nix)
- `devshell` - Development shell with PowerShell

**Usage:**
```bash
# Enter dev shell (or let direnv auto-load via .envrc)
nix develop

# Format code
nix fmt
```

The `.envrc` file enables automatic environment loading when entering the directory.

## Important Constraints

1. **Always use `sw` for git operations** - Using `git` directly will operate on the sync-windows repository itself, not the dotfiles
2. **Preserve the bare repo pattern** - Do not convert to a normal git repo or use symlinks
3. **Respect the .gitignore** - Personal files (Desktop, Downloads, Documents, etc.) should remain untracked
4. **Line endings are LF** - `.editorconfig` enforces Unix line endings even on Windows
5. **2-space indentation** - Standard across all files per `.editorconfig`
