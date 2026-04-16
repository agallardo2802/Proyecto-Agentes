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

# Copiar skill SDD a la raíz de skills para que esté disponible en autocomplete
$RootSkillDir = Join-Path $ConfigDir "sdd-ggs"
if (!(Test-Path $RootSkillDir)) {
    New-Item -ItemType Directory -Path $RootSkillDir -Force | Out-Null
}
Copy-Item -Path (Join-Path $SkillsDir "equipo\sdd-ggs\SKILL.md") -Destination (Join-Path $RootSkillDir "SKILL.md") -Force

# ============================================
# REGISTRAR AGENTES EN OPENCODE SELECTOR
# ============================================
if ($Agent.ToLower() -eq "opencode") {
    Write-Host ""
    Write-Host "Registering GGS agents in OpenCode selector..." -ForegroundColor Cyan

    $OpenCodeConfig = "$env:USERPROFILE\.config\opencode"
    $OpenCodeJson = Join-Path $OpenCodeConfig "opencode.json"

    # -------------------------------------------------------
    # LIMPIEZA: Borrar carpetas antiguas de agents/custom/
    # para evitar duplicados con prefijo "Custom/" en el dropdown
    # -------------------------------------------------------
    $CustomAgentsDir = Join-Path $OpenCodeConfig "agents\custom"
    $AgentsToClean = @("sdd-ggs", "Sdd-Ggs-Orchestrator", "Sdd-GGS-Orchestrator", "Sdd-GGS-Skills")
    foreach ($agentFolder in $AgentsToClean) {
        $path = Join-Path $CustomAgentsDir $agentFolder
        if (Test-Path $path) {
            Remove-Item -Recurse -Force $path
            Write-Host "  - Removed old agent/custom/$agentFolder" -ForegroundColor Gray
        }
    }

    # -------------------------------------------------------
    # REGISTRAR EN opencode.json
    # Los agent.md viven en skills/ggs/agents/ (parte del repo)
    # para que OpenCode no los auto-descubra como Custom/*
    # -------------------------------------------------------
    if (Test-Path $OpenCodeJson) {
        $json = Get-Content $OpenCodeJson -Raw | ConvertFrom-Json

        # --- sdd-ggs (hidden — motor interno) ---
        $sddGgsAgent = @{
            name        = "sdd-ggs"
            description = "Agente de desarrollo y procesos GGS - SDD con mejora continua"
            hidden      = $true
            mode        = "primary"
            model       = "opencode/minimax-m2.5-free"
            prompt      = "{file:./skills/ggs/equipo/sdd-ggs/agent.md}"
            tools       = @{ read = $true; edit = $true; write = $true; bash = $true; glob = $true; grep = $true }
        }
        $json.agent | Add-Member -NotePropertyName "sdd-ggs" -NotePropertyValue $sddGgsAgent -Force

        # --- Sdd-GGS-Orchestrator (modo automático) ---
        $orchestratorAgent = @{
            name        = "Sdd-GGS-Orchestrator"
            description = "SDD automático - valida, propone alternativas y espera OK antes de actuar"
            mode        = "primary"
            model       = "opencode/minimax-m2.5-free"
            prompt      = "{file:./skills/ggs/agents/Sdd-GGS-Orchestrator/agent.md}"
            tools       = @{ read = $true; edit = $true; write = $true; bash = $true; glob = $true; grep = $true }
        }
        $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Orchestrator" -NotePropertyValue $orchestratorAgent -Force

        # --- Sdd-GGS-Skills (modo manual) ---
        $skillsAgent = @{
            name        = "Sdd-GGS-Skills"
            description = "SDD manual - carga los skills y vos controlás cada paso del workflow"
            mode        = "primary"
            model       = "opencode/minimax-m2.5-free"
            prompt      = "{file:./skills/ggs/agents/Sdd-GGS-Skills/agent.md}"
            tools       = @{ read = $true; edit = $true; write = $true; bash = $true; glob = $true; grep = $true }
        }
        $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Skills" -NotePropertyValue $skillsAgent -Force

        # Guardar
        $json | ConvertTo-Json -Depth 10 | Set-Content -Path $OpenCodeJson
        Write-Host "  - Registered Sdd-GGS-Orchestrator in opencode.json" -ForegroundColor Green
        Write-Host "  - Registered Sdd-GGS-Skills in opencode.json" -ForegroundColor Green
    } else {
        Write-Host "  - opencode.json not found, skipping registration" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "GGS Agents installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To use:" -ForegroundColor White
Write-Host "  1. Open $Agent (restart if already open)" -ForegroundColor Gray
Write-Host "  2. Select 'Sdd-GGS-Orchestrator' or 'Sdd-GGS-Skills' from the selector" -ForegroundColor Gray
Write-Host "  3. Or type: sdd" -ForegroundColor Gray
Write-Host ""
Write-Host "For more info, see: $SkillsDir\README.md" -ForegroundColor Gray
