<#
.SYNOPSIS
Actualiza la distribucin GGS local sin pisar configuracin personal.

.DESCRIPTION
Este script es el punto de entrada v2 para equipos que ya instalaron ggs_agentes_base.
Actualiza el clon git local cuando existe y valida estructura. Para refrescar registros
de agentes en OpenCode, ejecutar install.ps1 -SkipPrerequisites despues del update.
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$ConfigureOpenCode,
    [switch]$UpdateGentleAI,
    [string]$Remote = "origin",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "GGS Agentes v2 - actualizacion" -ForegroundColor Cyan
Write-Host "Root: $Root"

if ($DryRun) {
    Write-Host "Modo DryRun: no se aplicaran cambios." -ForegroundColor Yellow
}

function Invoke-GentleAIUpdate {
    if ($DryRun) {
        Write-Host "DryRun: se omitio actualizacion manual de gentle-ai." -ForegroundColor Yellow
        return
    }

    Write-Host "Actualizando gentle-ai usando instalador oficial..." -ForegroundColor Cyan
    Invoke-RestMethod https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.ps1 | Invoke-Expression
}

function Test-OpenCodeConfig {
    $OpenCodeJson = Join-Path $env:USERPROFILE ".config\opencode\opencode.json"
    if (-not (Test-Path -LiteralPath $OpenCodeJson)) {
        Write-Host "OpenCode config no existe todavia: $OpenCodeJson" -ForegroundColor Yellow
        return $true
    }

    try {
        $null = Get-Content -LiteralPath $OpenCodeJson -Raw | ConvertFrom-Json
        Write-Host "OpenCode config JSON OK: $OpenCodeJson" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "OpenCode config invalida: $OpenCodeJson" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        return $false
    }
}

$GitDir = Join-Path $Root ".git"
if (Test-Path -LiteralPath $GitDir) {
    if ($DryRun) {
        Write-Host "DryRun: se omitio git pull $Remote $Branch."
    } else {
        Write-Host "Actualizando repositorio desde $Remote/$Branch..."
        git -C $Root pull $Remote $Branch
    }
} else {
    Write-Host "No se encontro .git; se asume instalacion copiada manualmente." -ForegroundColor Yellow
}

if ($UpdateGentleAI) {
    Invoke-GentleAIUpdate
}

$RequiredPaths = @(
    "skills",
    "agents",
    "templates",
    ".atl\skill-registry.md"
)

foreach ($Path in $RequiredPaths) {
    $FullPath = Join-Path $Root $Path
    if (-not (Test-Path -LiteralPath $FullPath)) {
        throw "Falta path requerido: $Path"
    }
}

Write-Host "Validacion de estructura OK." -ForegroundColor Green

if (-not (Test-OpenCodeConfig)) {
    throw "Abortado: opencode.json no es valido. No se refrescara configuracion de OpenCode."
}

if ($ConfigureOpenCode) {
    $InstallScript = Join-Path $PSScriptRoot "install.ps1"
    Write-Host "Refrescando registro de agentes GGS en OpenCode..." -ForegroundColor Cyan
    & $InstallScript -SkipPrerequisites -ConfigureOpenCodeOnly -Agent opencode -DryRun:$DryRun
    if (-not $?) { throw "Fallo refresh de OpenCode" }
} else {
    Write-Host "Para refrescar el selector de OpenCode: .\scripts\update.ps1 -ConfigureOpenCode" -ForegroundColor Yellow
}

Write-Host "Si OpenCode estaba abierto, reinicialo para cargar skills/agentes actualizados." -ForegroundColor Yellow
