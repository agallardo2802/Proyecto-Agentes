# ==============================================================================
# GGS DOCTOR - Diagnostico de instalacion (Windows)
# ==============================================================================
# Verifica el estado de la instalacion GGS/OpenCode y reporta que falta.
# Uso: .\scripts\doctor.ps1
# ==============================================================================

$null = & chcp 65001 2>$null
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$script:Issues = 0
function Check-Ok   { param($m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Check-Warn { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow; $script:Issues++ }
function Check-Fail { param($m) Write-Host "  [FAIL] $m" -ForegroundColor Red; $script:Issues++ }

Write-Host ""
Write-Host "=== GGS DOCTOR ===" -ForegroundColor Cyan
Write-Host ""

# 1. Herramientas base
Write-Host "Herramientas:" -ForegroundColor Cyan
foreach ($t in @(
    @{n="git"; c="git --version"},
    @{n="node"; c="node --version"},
    @{n="opencode"; c="opencode --version"},
    @{n="uv"; c="uv --version"}
)) {
    if (Get-Command $t.n -ErrorAction SilentlyContinue) {
        $v = (Invoke-Expression $t.c 2>$null | Select-Object -First 1)
        Check-Ok "$($t.n) -> $v"
    } else {
        if ($t.n -eq "uv") { Check-Warn "uv no encontrado (markitdown-mcp no funcionara)" }
        else { Check-Fail "$($t.n) no encontrado" }
    }
}
$engramPath = "$env:LOCALAPPDATA\engram\bin\engram.exe"
if (Test-Path $engramPath) { Check-Ok "engram -> $(& $engramPath version 2>$null)" }
else { Check-Warn "engram no encontrado (memoria persistente deshabilitada)" }

# 2. OpenCode config
Write-Host ""
Write-Host "OpenCode:" -ForegroundColor Cyan
$ocDir = "$env:USERPROFILE\.config\opencode"
$ocJson = Join-Path $ocDir "opencode.json"
if (Test-Path $ocJson) {
    try {
        $cfg = Get-Content -Raw -LiteralPath $ocJson | ConvertFrom-Json
        Check-Ok "opencode.json es JSON valido"
        foreach ($a in @("Arquitecto","Planificador","Revisor")) {
            if ($cfg.agent.$a) { Check-Ok "Agente '$a' registrado" }
            else { Check-Fail "Agente '$a' NO registrado" }
        }
        foreach ($m in @("engram","markitdown")) {
            if ($cfg.mcp.$m) {
                $en = if ($cfg.mcp.$m.enabled -eq $false) { "(deshabilitado)" } else { "(activo)" }
                Check-Ok "MCP '$m' configurado $en"
            } else { Check-Warn "MCP '$m' no configurado" }
        }
    } catch {
        Check-Fail "opencode.json NO es JSON valido: $ocJson"
    }
} else {
    Check-Fail "No existe opencode.json. Corre install.ps1"
}

# 3. Skills GGS
$skillsDir = Join-Path $ocDir "skills"
if (Test-Path (Join-Path $skillsDir "agents\Arquitecto\AGENT.md")) { Check-Ok "Skills GGS instalados" }
else { Check-Fail "Skills GGS no encontrados en $skillsDir" }

# 4. Logo TUI
Write-Host ""
Write-Host "Logo TUI:" -ForegroundColor Cyan
$pluginPath = Join-Path $ocDir "tui-plugins\gentle-logo.tsx"
$tuiJson = Join-Path $ocDir "tui.json"
if (Test-Path $pluginPath) { Check-Ok "Plugin de logo presente" }
else { Check-Warn "Plugin de logo no encontrado" }
if (Test-Path $tuiJson) {
    $tui = Get-Content -Raw -LiteralPath $tuiJson
    if ($tui -match "gentle-logo") { Check-Ok "Logo registrado en tui.json" }
    else { Check-Warn "Logo NO registrado en tui.json" }
} else { Check-Warn "tui.json no existe" }

# Resumen
Write-Host ""
if ($script:Issues -eq 0) {
    Write-Host "Todo OK. Instalacion GGS saludable." -ForegroundColor Green
} else {
    Write-Host "$($script:Issues) punto(s) requieren atencion. Revisa los [WARN]/[FAIL] de arriba." -ForegroundColor Yellow
    Write-Host "Tip: corre  .\scripts\install.ps1  (con GGS_AGENTS_SOURCE_DIR apuntando al clon) para reparar." -ForegroundColor Gray
}
Write-Host ""
