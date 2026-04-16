# GGS Agents Installer for Windows
# Usage: .\install.ps1 [opencode|claude|cursor] [repo-url]

param(
    [string]$Agent = "opencode",
    [string]$RepoUrl = "https://github.com/agallardo2802/Proyecto-Agentes.git"
)

Write-Host "Installing GGS Agents..." -ForegroundColor Cyan

# Determine config directory based on agent
switch ($Agent.ToLower()) {
    "opencode" { $ConfigDir = "$env:USERPROFILE\.config\opencode\skills" }
    "claude"   { $ConfigDir = "$env:USERPROFILE\.claude\skills" }
    "cursor"   { $ConfigDir = "$env:USERPROFILE\.cursor\skills" }
    "windsurf" { $ConfigDir = "$env:USERPROFILE\.windsurf\skills" }
    default    {
        Write-Host "Unknown agent: $Agent" -ForegroundColor Red
        Write-Host "Supported: opencode, claude, cursor, windsurf" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Installing for: $Agent" -ForegroundColor Gray
Write-Host "Config directory: $ConfigDir" -ForegroundColor Gray

# Create skills directory
if (!(Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

$SkillsDir = Join-Path $ConfigDir "ggs"

if (Test-Path $SkillsDir) {
    Write-Host "Updating existing installation..." -ForegroundColor Yellow
    Set-Location $SkillsDir
    git pull origin main
} else {
    Write-Host "Cloning repository..." -ForegroundColor Yellow
    git clone $RepoUrl $SkillsDir
}

Write-Host ""
Write-Host "GGS Agents installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To use:" -ForegroundColor White
Write-Host "  1. Open $Agent" -ForegroundColor Gray
Write-Host "  2. Type: sdd" -ForegroundColor Gray
Write-Host "  3. Or use: @equipo/desarrollo/dev" -ForegroundColor Gray
Write-Host ""
Write-Host "For more info, see: $SkillsDir\README.md" -ForegroundColor Gray