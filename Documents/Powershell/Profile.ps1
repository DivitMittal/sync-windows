#################################################################################
## Environment Variables
#################################################################################
$scoopPath = "$env:userprofile\scoop\apps"

$env:Path += ";$env:userprofile\.local\bin"
$env:Path += ";$env:userprofile\scoop\shims"
$env:Path += ";$scoopPath\msys2\current\mingw64\bin"

$EDITOR = "$env:userprofile\scoop\shims\vim.exe"
$env:EDITOR = "$EDITOR"
$env:VISUAL = "$EDITOR"
$env:SHELL = "pwsh"

#################################################################################
## Aliases
#################################################################################
## scoop-ultimate
function Invoke-UltimateScoop {
  scoop update
  scoop update --all
  scoop cleanup --all
  scoop cache rm *
}
Set-Alias -Name scoop-ultimate -Value Invoke-UltimateScoop

## winget-ultimate
function Invoke-UltimateWinget {
  winget source update
  winget list --upgrade-available  # winget upgrade/update
  winget upgrade --all
}
Set-Alias -Name winget-ultimate -Value Invoke-UltimateWinget

# store-ultimate
function Invoke-UltimateStore {
  store updates --apply 1
}
Set-Alias -Name store-ultimate -Value Invoke-UltimateStore

# msys
function Invoke-Msys { msys2 -shell fish }
Set-Alias -Name msys -Value Invoke-Msys

# windows-backup
function Invoke-WinPackageManagerBackup {
  $backupDir = "$env:userprofile/backup"
  New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

  scoop export | Set-Content -Path (Join-Path $backupDir "scoop_export.json")
  winget export -o (Join-Path $backupDir "winget_export.json") --include-versions --accept-source-agreements

  store installed > (Join-Path $backupDir "store_backup.txt")
  Get-InstalledModule > (Join-Path $backupDir "powershell_modules_backup.txt")
}
Set-Alias -Name windows-backup -Value Invoke-WinPackageManagerBackup

# windows-ultimate
function Invoke-UltimateWindows {
  scoop-ultimate
  winget-ultimate
  store-ultimate
  windows-backup
}
Set-Alias -Name windows-ultimate -Value Invoke-UltimateWindows

#################################################################################
# Implementation to manage dotfiles
#################################################################################
# sw (sync-windows)
function Invoke-GitWithCustomPaths {
  param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
  )

  $gitDir = "$env:userprofile/sync-windows/"
  $workTree = "$env:userprofile"

  $gitCommand = "git --git-dir=$gitDir --work-tree=$workTree " + $Arguments

  Invoke-Expression $gitCommand
}
Set-Alias -Name sw -Value Invoke-GitWithCustomPaths

#########################################################################################
# Initializations
#########################################################################################
fastfetch
Invoke-Expression (&starship init powershell)
