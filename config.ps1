# Symlink dotfiles into $HOME on Windows. .bashrc itself installs nvm,
# Node LTS, and Neovim on first Git Bash launch.

$ErrorActionPreference = 'Stop'

$repo = $PSScriptRoot
$files = @('.gitconfig', '.gitignore', '.bashrc')

foreach ($file in $files) {
    $target = Join-Path $HOME $file
    $source = Join-Path $repo $file

    $existing = Get-Item -Path $target -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink') {
            Remove-Item -Path $target -Force
        }
        else {
            $backupPath = "$target.bak"
            try {
                Move-Item -Path $target -Destination $backupPath -Force -ErrorAction Stop
            }
            catch {
                throw "Failed to back up existing $file to $file.bak: $_"
            }
            if (-not (Test-Path $backupPath)) {
                throw "Backup of $file to $file.bak did not complete; aborting before symlinking."
            }
            Write-Host "backed up existing $file to $file.bak"
        }
    }

    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
}

Write-Host "Done. Open Git Bash - first launch will install nvm, Node LTS, and Neovim."
