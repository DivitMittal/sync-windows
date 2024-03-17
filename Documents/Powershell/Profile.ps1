#################################################################################
# Environment Variables
#################################################################################
$env:Path += 'C:\Users\div\scoop\apps\neovim\0.9.5\bin;'

#################################################################################
# Aliases
#################################################################################
### windows-backup
function Invoke-WinPackageManagerBackup {
    $backupDir = "$HOME/backup/"
    scoop list > "$backupDir/scoop_backup.txt"
    winget list > "$backupDir/winget_backup.txt"
}
Set-Alias -Name windows-backup -Value Invoke-WinPackageManagerBackup

### windows-ultimate
function Invoke-UltimateWin {
    scoop update
    scoop update --all
    scoop cleanup --all
    winget upgrade --all
    windows-backup
}
Set-Alias -Name windows-ultimate -Value Invoke-UltimateWin

### Eza
$ezaParams = @("--all", "--classify", "--icons=always", "--group-directories-first", "--color=always", "--color-scale", "--color-scale-mode=gradient", "--hyperlink")
function Invoke-LsViaEza {
    $lsCommand = "eza " + ($ezaParams -join " ")
    Invoke-Expression $lsCommand
}
Set-Alias -Name ls -Value Invoke-LsViaEza
function Invoke-LlViaEza {
    $llCommand = "eza -lbhHigUmuSa@ " + ($ezaParams -join " ")
    Invoke-Expression $llCommand
}
Set-Alias -Name ll -Value Invoke-LlViaEza

#################################################################################
# Implementation to manage dotfiles
#################################################################################
# sw (sync-windows)
function Invoke-GitWithCustomPaths {
    param(
        [string[]]$Arguments
    )

    # Set custom paths
    $gitDir = "$HOME/sync-windows/"
    $workTree = "$HOME"

    # Build git command with custom paths
    $gitCommand = "git --git-dir=$gitDir --work-tree=$workTree"

    # Append provided arguments to the git command
    $gitCommand += " " + ($Arguments -join " ")

    # Invoke the git command
    Invoke-Expression $gitCommand
}
Set-Alias -Name sw -Value Invoke-GitWithCustomPaths

################################################################################
# Utility functions for zoxide.
################################################################################
# Call zoxide binary, returning the output as UTF-8.
function global:__zoxide_bin {
    $encoding = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = [System.Text.Utf8Encoding]::new()
        $result = zoxide @args
        return $result
    } finally {
        [Console]::OutputEncoding = $encoding
    }
}
# pwd based on zoxide's format.
function global:__zoxide_pwd {
    $cwd = Get-Location
    if ($cwd.Provider.Name -eq "FileSystem") {
        $cwd.ProviderPath
    }
}
# cd + custom logic based on the value of _ZO_ECHO.
function global:__zoxide_cd($dir, $literal) {
    $dir = if ($literal) {
        Set-Location -LiteralPath $dir -Passthru -ErrorAction Stop
    } else {
        if ($dir -eq '-' -and ($PSVersionTable.PSVersion -lt 6.1)) {
            Write-Error "cd - is not supported below PowerShell 6.1. Please upgrade your version of PowerShell."
        }
        elseif ($dir -eq '+' -and ($PSVersionTable.PSVersion -lt 6.2)) {
            Write-Error "cd + is not supported below PowerShell 6.2. Please upgrade your version of PowerShell."
        }
        else {
            Set-Location -Path $dir -Passthru -ErrorAction Stop
        }
    }
}
# Hook configuration for zoxide.
# Hook to add new entries to the database.
$global:__zoxide_oldpwd = __zoxide_pwd
function global:__zoxide_hook {
    $result = __zoxide_pwd
    if ($result -ne $global:__zoxide_oldpwd) {
        if ($null -ne $result) {
            zoxide add -- $result
        }
        $global:__zoxide_oldpwd = $result
    }
}
# Initialize hook.
$global:__zoxide_hooked = (Get-Variable __zoxide_hooked -ErrorAction SilentlyContinue -ValueOnly)
if ($global:__zoxide_hooked -ne 1) {
    $global:__zoxide_hooked = 1
    $global:__zoxide_prompt_old = $function:prompt
    function global:prompt {
        if ($null -ne $__zoxide_prompt_old) {
            & $__zoxide_prompt_old
        }
        $null = __zoxide_hook
    }
}
# When using zoxide with --no-cmd, alias these internal functions as desired.
# Jump to a directory using only keywords.
function global:__zoxide_z {
    if ($args.Length -eq 0) {
        __zoxide_cd ~ $true
    }
    elseif ($args.Length -eq 1 -and ($args[0] -eq '-' -or $args[0] -eq '+')) {
        __zoxide_cd $args[0] $false
    }
    elseif ($args.Length -eq 1 -and (Test-Path $args[0] -PathType Container)) {
        __zoxide_cd $args[0] $true
    }
    else {
        $result = __zoxide_pwd
        if ($null -ne $result) {
            $result = __zoxide_bin query --exclude $result -- @args
        }
        else {
            $result = __zoxide_bin query -- @args
        }
        if ($LASTEXITCODE -eq 0) {
            __zoxide_cd $result $true
        }
    }
}
# Jump to a directory using interactive search.
function global:__zoxide_zi {
    $result = __zoxide_bin query -i -- @args
    if ($LASTEXITCODE -eq 0) {
        __zoxide_cd $result $true
    }
}
# Commands for zoxide. Disable these using --no-cmd.
Set-Alias -Name cd -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name cdi -Value __zoxide_zi -Option AllScope -Scope Global -Force

#########################################################################################
# Initializations
#########################################################################################
# Winfetch
winfetch

# Starship prompt
Invoke-Expression (&starship init powershell)

