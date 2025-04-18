<h1 align='center'> sync-windows </h1>

![dotfiles](./../assets/dotfiles.svg) ![windows](./../assets/windows.png)

These are dotfiles, preference files, configuration files, shell scripts, etc., tailored for a Microsoft Windows environment.

## Dotfile Synchronization with `sw`

This repository utilizes a clever technique to manage dotfiles directly within your user profile directory (`$env:userprofile`) using Git. The core of this system is the `sw` (sync-windows) alias defined in `Documents/Powershell/Profile.ps1`.

**How it works:**

The `sw` command is an alias for a PowerShell function that invokes `git` with specific parameters:

- `--git-dir=$env:userprofile/sync-windows/`: Specifies that the Git repository data (the `.git` directory, essentially) resides within this project's directory located directly under your user profile.
- `--work-tree=$env:userprofile`: Sets the working directory for Git to your entire user profile directory.

This means you can run standard Git commands using `sw` instead of `git` to track, manage, and synchronize any file within your user profile directory using this repository.

**Example Usage:**

```powershell
# Check the status of tracked files in your home directory
sw status

# Add a configuration file to be tracked
sw add .config/my-app/settings.json

# Commit changes
sw commit -m "Update my-app settings"

# Push changes to the remote repository
sw push
```

This approach allows for seamless version control and synchronization of my Windows environment configuration.
