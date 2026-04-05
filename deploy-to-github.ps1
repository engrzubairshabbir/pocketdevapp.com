# PocketDev - push this folder to GitHub (pocketdevapp.com live site)
# Run: cd website ; .\deploy-to-github.ps1
# Requires: Git for Windows. First push: sign in when Git asks (browser or PAT).

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/engrzubairshabbir/pocketdevapp.com.git"
$WebsiteRoot = $PSScriptRoot

if (Test-Path "$env:ProgramFiles\Git\bin\git.exe") {
    $env:Path = "$env:ProgramFiles\Git\bin;" + $env:Path
}

function Find-Git {
    $candidates = @(
        (Get-Command git -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source),
        "$env:ProgramFiles\Git\bin\git.exe",
        "${env:ProgramFiles(x86)}\Git\bin\git.exe",
        "$env:LOCALAPPDATA\Programs\Git\bin\git.exe",
        "$env:ProgramFiles\Git\cmd\git.exe"
    ) | Where-Object { $_ -and (Test-Path $_) }
    if ($candidates.Count -eq 0) { return $null }
    return $candidates[0]
}

$git = Find-Git
if (-not $git) {
    Write-Host "Git was not found. Install from https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

Write-Host "Using Git: $git" -ForegroundColor Green
Set-Location $WebsiteRoot

if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Cyan
    & $git init
    & $git remote add origin $RepoUrl
} else {
    Write-Host "Git repo already exists." -ForegroundColor Cyan
    $hasOrigin = & $git remote get-url origin 2>$null
    if (-not $hasOrigin) {
        & $git remote add origin $RepoUrl
    }
}

& $git branch -M main 2>$null

$userName = & $git config user.name 2>$null
if (-not $userName) {
    Write-Host "Setting local git identity for this repo..." -ForegroundColor Yellow
    & $git config user.name "PocketDev Site"
    & $git config user.email "hello@pocketdevapp.com"
}

& $git add -A
$status = & $git status --porcelain
if (-not $status) {
    Write-Host "Nothing to commit (no changes)." -ForegroundColor Yellow
} else {
    $msg = "Update PocketDev site and release assets (" + (Get-Date -Format 'yyyy-MM-dd') + ")"
    & $git commit -m $msg
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit failed. Run: git config --global user.name YourName" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Pushing to origin main..." -ForegroundColor Cyan
& $git push -u origin main
$pushOk = $LASTEXITCODE

if ($pushOk -ne 0) {
    Write-Host ""
    Write-Host "If rejected, run in this folder:" -ForegroundColor Yellow
    Write-Host "  git pull origin main --allow-unrelated-histories --no-edit"
    Write-Host "  git push -u origin main"
    Write-Host ""
    Write-Host "Push failed - sign in to GitHub when Git asks (browser or PAT)." -ForegroundColor Red
    Write-Host "Or: winget install GitHub.cli  then  gh auth login" -ForegroundColor White
    exit 1
}

Write-Host "Done. Wait 1-2 minutes, then open https://pocketdevapp.com" -ForegroundColor Green
