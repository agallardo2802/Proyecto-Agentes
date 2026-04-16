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
# REGISTRAR AGENTE EN OPENCODE SELECTOR
# ============================================
if ($Agent.ToLower() -eq "opencode") {
    Write-Host ""
    Write-Host "Registering sdd-ggs in OpenCode selector..." -ForegroundColor Cyan

    $OpenCodeConfig = "$env:USERPROFILE\.config\opencode"
    $AgentsDir = Join-Path $OpenCodeConfig "agents\custom\sdd-ggs"
    $OpenCodeJson = Join-Path $OpenCodeConfig "opencode.json"

    # Crear directorio del agente
    if (!(Test-Path $AgentsDir)) {
        New-Item -ItemType Directory -Path $AgentsDir -Force | Out-Null
    }

    # Copiar agent.md
    $AgentMdSource = Join-Path $SkillsDir "equipo\sdd-ggs\agent.md"
    $AgentMdDest = Join-Path $AgentsDir "agent.md"

    # Si no existe agent.md en el repo, crear uno básico
    if (!(Test-Path $AgentMdSource)) {
        $AgentMdContent = @"
# Agente SDD-GGS

## System Prompt

Eres **sdd-ggs**, un agente de desarrollo y procesos especializado en Spec-Driven Development (SDD) con enfoque de mejora continua.

## Regla Fundamental: VALIDAR ANTES DE ACTUAR

**NUNCA ejecutés directamente — siempre validá, dalle alternativas, y esperá aprobación.**

## Principios

- CONCEPTOS > CÓDIGO
- MEJORA CONTINUA
- CLARIDAD OPERATIVA
- MEDIBLE
"@
        Set-Content -Path $AgentMdDest -Value $AgentMdContent
    } else {
        Copy-Item -Path $AgentMdSource -Destination $AgentMdDest -Force
    }

    # Actualizar opencode.json
    if (Test-Path $OpenCodeJson) {
        $json = Get-Content $OpenCodeJson -Raw | ConvertFrom-Json

        # Verificar si ya existe sdd-ggs
        $exists = $json.agent.PSObject.Properties.Name -contains "sdd-ggs"

        if (!$exists) {
            # Agregar agente
            $newAgent = @{
                name = "sdd-ggs"
                description = "Agente de desarrollo y procesos GGS - SDD con mejora continua"
                mode = "primary"
                model = "opencode/minimax-m2.5-free"
                prompt = "{file:./agents/custom/sdd-ggs/agent.md}"
                tools = @{
                    read = $true
                    edit = $true
                    write = $true
                    bash = $true
                    glob = $true
                    grep = $true
                }
            }

            # Convertir a JSON y agregar al inicio del agent
            $json.agent | Add-Member -NotePropertyName "sdd-ggs" -NotePropertyValue $newAgent -Force

            # Reordenar para que aparezca primero
            $agentOrder = @("sdd-ggs") + ($json.agent.PSObject.Properties.Name | Where-Object { $_ -ne "sdd-ggs" })
            $newAgentObj = [ordered]@{}
            foreach ($a in $agentOrder) {
                $newAgentObj[$a] = $json.agent.$a
            }
            $json.agent = $newAgentObj

            # Guardar
            $json | ConvertTo-Json -Depth 10 | Set-Content -Path $OpenCodeJson
            Write-Host "  - Registered sdd-ggs in opencode.json" -ForegroundColor Green
        } else {
            Write-Host "  - sdd-ggs already registered" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  - opencode.json not found, skipping registration" -ForegroundColor Yellow
    }

    Write-Host "  - Agent files copied to: $AgentsDir" -ForegroundColor Gray
}

Write-Host ""
Write-Host "GGS Agents installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To use:" -ForegroundColor White
Write-Host "  1. Open $Agent (restart if already open)" -ForegroundColor Gray
Write-Host "  2. Select 'sdd-ggs' from the mode selector" -ForegroundColor Gray
Write-Host "  3. Or type: sdd" -ForegroundColor Gray
Write-Host ""
Write-Host "For more info, see: $SkillsDir\README.md" -ForegroundColor Gray