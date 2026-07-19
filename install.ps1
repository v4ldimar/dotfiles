# Ensure Git Bash is available (installing Git for Windows via winget if
# not), then hand off to install.sh for the real OS-aware install logic.

$ErrorActionPreference = 'Stop'

$defaultBashPath = Join-Path $env:ProgramFiles 'Git\bin\bash.exe'

# Prefer the known Git Bash install path over a PATH search: on Windows,
# C:\Windows\System32\bash.exe (the WSL launcher) often precedes Git Bash on
# PATH, so a plain `Get-Command bash.exe` can silently pick WSL instead.
if (Test-Path $defaultBashPath) {
    $bashPath = $defaultBashPath
}
else {
    $bashCommand = Get-Command bash.exe -ErrorAction SilentlyContinue |
        Where-Object { $_.Source -notlike "$env:WINDIR\*" } |
        Select-Object -First 1
    if ($bashCommand) {
        $bashPath = $bashCommand.Source
    }
    else {
        $bashPath = $null
    }
}

if (-not $bashPath) {
    Write-Host "==> Git Bash not found, installing Git for Windows via winget"
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget not found. Install Git for Windows manually: https://git-scm.com/download/win"
    }
    winget install --id Git.Git -e --source winget `
        --accept-package-agreements --accept-source-agreements

    if (-not (Test-Path $defaultBashPath)) {
        throw "Git for Windows was installed but bash.exe was not found at the expected path: $defaultBashPath"
    }
    $bashPath = $defaultBashPath
}

$installSh = Join-Path $PSScriptRoot 'install.sh'
& $bashPath $installSh
exit $LASTEXITCODE
