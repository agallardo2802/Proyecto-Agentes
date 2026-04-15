# ============================================================
# Script: Importar agentes propios a gentle-ai
# ============================================================
# Este script copia tus carpetas de agentes (equipo, reglas, guilds)
# a los directorios de skills de los agentes configurados.
#
# Uso: .\importar-agentes.ps1
# ============================================================

$ErrorActionPreference = "Stop"

# ============================================================
# CONFIGURACION
# ============================================================

# Ruta base del repo — se detecta automáticamente desde la ubicación del script
$ArquitecturaAgentesPath = $PSScriptRoot

# Carpetas a importar (desde el repo de arquitectura)
$CarpetasAImportar = @("equipo", "reglas", "guilds", "orchestrator")

# Skills especiales que siempre se actualizan (aunque ya existan)
# Estos se sincronizan con -Force para updates
$SkillsEspeciales = @("sdd-ggsoluciones")

# Directorios de skills por agente (user-level)
$AgentSkillDirs = @{
    "Claude Code"    = "$env:USERPROFILE\.claude\skills"
    "Cursor"         = "$env:USERPROFILE\.cursor\skills"
    "OpenCode"       = "$env:USERPROFILE\.config\opencode\skills"
    "Gemini CLI"     = "$env:USERPROFILE\.gemini\skills"
    "VS Code Copilot" = "$env:USERPROFILE\.copilot\skills"
}

# ============================================================
# FUNCIONES
# ============================================================

function Write-Status {
    param([string]$Message, [string]$Type = "info")
    $colors = @{
        "info"    = "Cyan"
        "success" = "Green"
        "warning" = "Yellow"
        "error"   = "Red"
    }
    Write-Host "[$($Type.ToUpper())] $Message" -ForegroundColor $colors[$Type]
}

function Test-PathExists {
    param([string]$Path)
    if (Test-Path $Path) {
        return $true
    }
    return $false
}

function Import-AgentesToAgent {
    param(
        [string]$AgentName,
        [string]$SkillDir,
        [string]$SourcePath,
        [string[]]$Carpetas,
        [string[]]$SkillsEspeciales
    )
    
    Write-Status "Procesando $AgentName..." "info"
    
    # Verificar que existe el directorio de skills
    if (-not (Test-PathExists $SkillDir)) {
        Write-Status "  directorio de skills no existe, creando..." "warning"
        New-Item -ItemType Directory -Path $SkillDir -Force | Out-Null
    }
    
    $importados = 0
    $omitidos = 0
    $actualizados = 0
    
    # 1. Importar carpetas normales (solo si no existen)
    foreach ($carpeta in $Carpetas) {
        $sourceFullPath = Join-Path $SourcePath $carpeta
        $destPath = Join-Path $SkillDir $carpeta
        
        if (-not (Test-PathExists $sourceFullPath)) {
            Write-Status "  carpeta '$carpeta' no existe en el source, omitiendo..." "warning"
            $omitidos++
            continue
        }
        
        if (Test-PathExists $destPath) {
            Write-Status "  $carpeta ya existe en $AgentName, omitiendo..." "info"
            $omitidos++
            continue
        }
        
        Copy-Item -Path $sourceFullPath -Destination $destPath -Recurse -Force
        Write-Status "  importado: $carpeta -> $AgentName" "success"
        $importados++
    }
    
    # 2. Sincronizar skills especiales (siempre actualiza)
    foreach ($skill in $SkillsEspeciales) {
        $sourceFullPath = Join-Path $SourcePath "equipo\$skill"
        $destPath = Join-Path $SkillDir "equipo\$skill"
        
        if (-not (Test-PathExists $sourceFullPath)) {
            Write-Status "  skill especial '$skill' no existe en el source, omitiendo..." "warning"
            continue
        }
        
        # Crear directorio equipo si no existe
        $equipoDir = Join-Path $SkillDir "equipo"
        if (-not (Test-PathExists $equipoDir)) {
            New-Item -ItemType Directory -Path $equipoDir -Force | Out-Null
        }
        
        # Siempre actualizar (force)
        Copy-Item -Path $sourceFullPath -Destination $destPath -Recurse -Force
        Write-Status "  sincronizado: $skill -> $AgentName" "success"
        $actualizados++
    }
    
    return @{
        AgentName = $AgentName
        Importados = $importados
        Omitidos = $omitidos
        Actualizados = $actualizados
    }
}

# ============================================================
# EJECUCION PRINCIPAL
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  IMPORTAR AGENTES A GENTLE-AI" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

# Verificar que existe el repo de arquitectura
if (-not (Test-PathExists $ArquitecturaAgentesPath)) {
    Write-Status "No se encontro el repo de arquitectura en: $ArquitecturaAgentesPath" "error"
    exit 1
}

Write-Status "Repo de arquitectura encontrado: $ArquitecturaAgentesPath" "success"
Write-Status "Carpetas a importar: $($CarpetasAImportar -join ', ')" "info"
Write-Status "Skills especiales (sync): $($SkillsEspeciales -join ', ')" "info"
Write-Host ""

# Listar carpetas disponibles
Write-Status "Carpetas disponibles en el repo:" "info"
foreach ($carpeta in $CarpetasAImportar) {
    $path = Join-Path $ArquitecturaAgentesPath $carpeta
    if (Test-PathExists $path) {
        $count = (Get-ChildItem -Path $path -Filter "*.md" -Recurse).Count
        Write-Host "  - $carpeta ($count archivos .md)"
    }
}
Write-Host ""

# Listar skills especiales
Write-Status "Skills especiales a sincronizar:" "info"
foreach ($skill in $SkillsEspeciales) {
    $path = Join-Path $ArquitecturaAgentesPath "equipo\$skill"
    if (Test-PathExists $path) {
        Write-Host "  - $skill"
    } else {
        Write-Host "  - $skill (NO ENCONTRADO)" -ForegroundColor Yellow
    }
}
Write-Host ""

# Procesar cada agente
$results = @()
Write-Status "Iniciando importacion a agentes..." "info"
Write-Host ""

foreach ($agent in $AgentSkillDirs.GetEnumerator()) {
    $result = Import-AgentesToAgent -AgentName $agent.Name -SkillDir $agent.Value -SourcePath $ArquitecturaAgentesPath -Carpetas $CarpetasAImportar -SkillsEspeciales $SkillsEspeciales
    $results += $result
}

# ============================================================
# RESUMEN
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  RESUMEN" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

$totalImportados = 0
$totalActualizados = 0
foreach ($r in $results) {
    Write-Host ""
    Write-Host "Agente: $($r.AgentName)" -ForegroundColor White
    Write-Host "  - Importados: $($r.Importados)" -ForegroundColor $(if ($r.Importados -gt 0) { "Green" } else { "Yellow" })
    Write-Host "  - Omitidos:   $($r.Omitidos)" -ForegroundColor Yellow
    Write-Host "  - Sincronizados: $($r.Actualizados)" -ForegroundColor Cyan
    $totalImportados += $r.Importados
    $totalActualizados += $r.Actualizados
}

Write-Host ""
Write-Host "Total de carpetas importadas: $totalImportados" -ForegroundColor Green
Write-Host "Total de skills sincronizados: $totalActualizados" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# PROXIMOS PASOS
# ============================================================

Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  PROXIMOS PASOS" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "1. En tu proyecto, ejecuta: /skill-registry" -ForegroundColor White
Write-Host "   Esto escaneara tus skills y creara el registry."
Write-Host ""
Write-Host "2. Para iniciar SDD completo: /sdd-ggsoluciones" -ForegroundColor White
Write-Host ""
Write-Host "3. Los agentes se activaran cuando el trigger coincida."
Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
