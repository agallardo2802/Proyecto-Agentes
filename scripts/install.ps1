# ==============================================================================
# GGS AGENTS - INSTALADOR PARA NUEVOS DESARROLLADORES
# ==============================================================================
# Este script instala TODO lo necesario para comenzar a trabajar con los
# agentes GGS de GGSoluciones: herramientas base + agentes.
#
# Uso: .\install.ps1
# O: .\install.ps1 -OnlyPrerequisites (solo herramientas, no agentes)
# ==============================================================================

param(
    [switch]$SkipPrerequisites,  # Saltar instalacin de herramientas base
    [switch]$OnlyPrerequisites,  # Solo instalar herramientas, no agentes
    [switch]$SkipAgents,         # Solo instalar herramientas, no agentes (alias)
    [switch]$DryRun,             # Mostrar acciones sin aplicar cambios destructivos/config
    [switch]$NoConfigureOpenCode,# Instalar/actualizar agentes sin tocar opencode.json
    [switch]$NoInstallClaude,    # No instalar skills GGS en Claude Code cuando Agent=opencode
    [switch]$NoInstallCompanionAgents, # No instalar skills GGS en Claude/Codex/Antigravity cuando Agent=opencode
    [switch]$ConfigureOpenCodeOnly, # Solo refrescar registro de agentes en opencode.json
    [switch]$UpdateGentleAI,     # Actualizar gentle-ai CLI usando instalador oficial
    [string]$Agent = "opencode"  # opencode, claude, codex, antigravity, cursor, windsurf
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$CodexAvailable = [bool](Get-Command codex -ErrorAction SilentlyContinue)
$DefaultOpenCodeModel = if ($env:GGS_OPENCODE_DEFAULT_MODEL) { $env:GGS_OPENCODE_DEFAULT_MODEL } elseif ($CodexAvailable) { "openai/gpt-5.5" } else { $null }
$SddProfileModel = if ($env:GGS_OPENCODE_DEFAULT_MODEL) { $env:GGS_OPENCODE_DEFAULT_MODEL } else { "openai/gpt-5.5" }
$LegacyOpenCodeDefaultModels = @(
    "opencode/minimax-m2.5-free",
    "ggsoluciones-ai/minimax-m2.7",
    "minimax-coding-plan/MiniMax-M2.7",
    "minimax-coding-plan/MiniMax-M2.7-highspeed",
    "google/gemini-3.5-flash"
)

# Alias
if ($SkipAgents) { $OnlyPrerequisites = $true }

# Colores
function Write-Step { param($msg) Write-Host "   $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "   $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "    $msg" -ForegroundColor Yellow }
function Write-Info { param($msg) Write-Host "    $msg" -ForegroundColor Gray }
function Write-Fatal { param($msg) Write-Host "   $msg" -ForegroundColor Red }

function Install-WingetPackage {
    param(
        [Parameter(Mandatory=$true)][string]$Id,
        [Parameter(Mandatory=$true)][string]$Name
    )

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Warn "winget no encontrado. Instala $Name manualmente."
        return $false
    }

    if ($DryRun) {
        Write-Info "DryRun: winget install --id $Id -e --accept-package-agreements --accept-source-agreements"
        return $true
    }

    try {
        winget install --id $Id -e --accept-package-agreements --accept-source-agreements | Out-Null
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Success "$Name instalado"
        return $true
    } catch {
        Write-Warn "No se pudo instalar $Name con winget. Instalar manualmente."
        return $false
    }
}

function Backup-File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$BackupRoot
    )

    if (!(Test-Path -LiteralPath $Path)) { return $null }
    if (!(Test-Path -LiteralPath $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null }

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $leaf = Split-Path -Leaf $Path
    $backupPath = Join-Path $BackupRoot "$leaf.$timestamp.bak"
    Copy-Item -LiteralPath $Path -Destination $backupPath -Force
    return $backupPath
}

function Install-GentleAI {
    Write-Step "Actualizando Gentle AI CLI..."
    if ($DryRun) {
        Write-Info "DryRun: se ejecutaria instalador oficial de Gentle AI para Windows"
        return $true
    }

    try {
        Invoke-RestMethod https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.ps1 | Invoke-Expression
        $gentle = Get-Command gentle-ai -ErrorAction SilentlyContinue
        if ($gentle) {
            $version = gentle-ai --version 2>&1
            Write-Success "Gentle AI actualizado: $version"
        } else {
            Write-Warn "Gentle AI actualizado, pero no se encontro en PATH actual. Reinicia la terminal."
        }
        return $true
    } catch {
        Write-Fatal "Error actualizando Gentle AI: $($_.Exception.Message)"
        return $false
    }
}

$logoLines = @(
"   ██████████              ██████████   ",
"     ████████████████        ████████████████ ",
"    █████        █████      █████        █████",
"    ████                    ████              ",
"    ████                    ████              ",
"    ████       ████████     ████       ████████",
"    ████       ████████     ████       ████████",
"    ████         █████      ████         █████ ",
"     ████████████████        ████████████████ ",
"       ██████████              ██████████     ",
"      S  O  L  U  C  I  O  N  E  S           "
)

Write-Host ""
foreach ($line in $logoLines) { Write-Host $line -ForegroundColor Red }
Write-Host ""
Write-Host ""

Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "   GGS AGENTS - INSTALADOR PARA NUEVOS DESARROLLADORES" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host ""

# ==============================================================================
# 1. VERIFICAR/INSTALAR GIT
# ==============================================================================
function Install-Git {
    Write-Step "Verificando Git..."

    $git = Get-Command git -ErrorAction SilentlyContinue
    if ($git) {
        $version = git --version | ForEach-Object { $_ -replace 'git version ', '' }
        Write-Success "Git instalado: $version"
        return $true
    }

    Write-Warn "Git no encontrado. Intentando instalar..."
    if ($DryRun) { Write-Info "DryRun: se descargaria e instalaria Git for Windows"; return $true }
    try {
        $gitInstaller = "$env:TEMP\git-installer.exe"
        Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.45.1.windows.1/Git-2.45.1-64-bit.exe" -OutFile $gitInstaller -UseBasicParsing -TimeoutSec 120
        Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT /NORESTART /NOCANCEL" -Wait
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Success "Git instalado correctamente"
        return $true
    } catch {
        Write-Fatal "Error installing Git: https://git-scm.com"
        return $false
    }
}

# ==============================================================================
# 2. VERIFICAR/INSTALAR PYTHON
# ==============================================================================
function Install-Python {
    Write-Step "Verificando Python..."

    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        try {
            $version = python --version 2>&1
            if ($LASTEXITCODE -eq 0 -and "$version" -match "Python") {
                Write-Success "Python instalado: $version"
                return $true
            }
        } catch { }
        Write-Warn "Alias de Python encontrado pero no usable. Se intentara instalar Python real."
    }

    Write-Warn "Python no encontrado. Descargando..."
    if ($DryRun) { Write-Info "DryRun: se descargaria e instalaria Python 3.12"; return $true }
    try {
        $pyInstaller = "$env:TEMP\python-installer.exe"
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe" -OutFile $pyInstaller -UseBasicParsing -TimeoutSec 180
        Start-Process -FilePath $pyInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Success "Python instalado correctamente"
        return $true
    } catch {
        Write-Fatal "Error installing Python: https://www.python.org"
        return $false
    }
}

# ==============================================================================
# 3. VERIFICAR DOCKER
# ==============================================================================
function Install-Docker {
    Write-Step "Verificando Docker..."

    $docker = Get-Command docker -ErrorAction SilentlyContinue
    if ($docker) {
        $version = docker --version 2>&1
        Write-Success "Docker instalado: $version"
        try { docker info 2>&1 | Out-Null; Write-Success "Docker est corriendo" } catch { Write-Warn "Docker instalado pero no corriendo" }
        return $true
    }

    Write-Warn "Docker no encontrado. Intentando instalar Docker Desktop..."
    return Install-WingetPackage -Id "Docker.DockerDesktop" -Name "Docker Desktop"
}

# ==============================================================================
# 4. VERIFICAR/INSTALAR .NET SDK
# ==============================================================================
function Install-DotNet {
    Write-Step "Verificando .NET SDK..."

    $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
    if ($dotnet) {
        $version = dotnet --version 2>&1
        Write-Success ".NET SDK instalado: $version"
        return $true
    }

    Write-Warn ".NET SDK no encontrado. Descargando..."
    if ($DryRun) { Write-Info "DryRun: se descargaria e instalaria .NET SDK 8"; return $true }
    try {
        Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile "$env:TEMP\dotnet-install.ps1" -UseBasicParsing
        powershell -ExecutionPolicy Bypass -File "$env:TEMP\dotnet-install.ps1" -Channel 8.0
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        $version = dotnet --version 2>&1
        Write-Success ".NET SDK 8 instalado: $version"
        return $true
    } catch {
        Write-Fatal "Error installing .NET: https://dotnet.microsoft.com/download"
        return $false
    }
}

# ==============================================================================
# 5. INSTALAR NODE.JS
# ==============================================================================
function Install-NodeJS {
    Write-Step "Verificando Node.js..."

    $node = Get-Command node -ErrorAction SilentlyContinue
    if ($node) {
        $version = node --version 2>&1
        Write-Success "Node.js instalado: $version"
        return $true
    }

    Write-Warn "Node.js no encontrado. Descargando..."
    if ($DryRun) { Write-Info "DryRun: se descargaria e instalaria Node.js LTS"; return $true }
    try {
        $nodeInstaller = "$env:TEMP\node-installer.msi"
        Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.13.1/node-v20.13.1-x64.msi" -OutFile $nodeInstaller -UseBasicParsing -TimeoutSec 120
        Start-Process msiexec.exe -ArgumentList "/i `"$nodeInstaller`" /quiet /norestart" -Wait
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        $version = node --version 2>&1
        Write-Success "Node.js instalado: $version"
        return $true
    } catch {
        Write-Fatal "Error installing Node.js: https://nodejs.org"
        return $false
    }
}

# ==============================================================================
# 6. INSTALAR GO
# ==============================================================================
function Install-Go {
    Write-Step "Verificando Go..."

    $go = Get-Command go -ErrorAction SilentlyContinue
    if ($go) {
        $version = go version 2>&1
        Write-Success "Go instalado: $version"
        return $true
    }

    Write-Warn "Go no encontrado. Instalando Go..."
    return Install-WingetPackage -Id "GoLang.Go" -Name "Go"
}

# ==============================================================================
# 7. WINDOWS TERMINAL
# ==============================================================================
function Install-Terminal {
    Write-Step "Verificando Windows Terminal..."

    $wt = Get-Command wt -ErrorAction SilentlyContinue
    if ($wt) { Write-Success "Windows Terminal instalado"; return $true }

    Write-Warn "Windows Terminal no encontrado. Intentando instalar..."
    return Install-WingetPackage -Id "Microsoft.WindowsTerminal" -Name "Windows Terminal"
}

# ==============================================================================
# 8. INSTALAR VISUAL STUDIO CODE
# ==============================================================================
function Install-VSCode {
    Write-Step "Verificando Visual Studio Code..."

    $code = Get-Command code -ErrorAction SilentlyContinue
    if ($code) { Write-Success "Visual Studio Code instalado"; return $true }

    Write-Warn "Visual Studio Code no encontrado. Instalando..."
    return Install-WingetPackage -Id "Microsoft.VisualStudioCode" -Name "Visual Studio Code"
}

# ==============================================================================
# 9. INSTALAR SLACK
# ==============================================================================
function Install-Slack {
    Write-Step "Verificando Slack..."

    $slack = Get-Command slack -ErrorAction SilentlyContinue
    if ($slack) { Write-Success "Slack instalado"; return $true }

    $slackPaths = @(
        "$env:LOCALAPPDATA\slack\slack.exe",
        "$env:ProgramFiles\Slack\slack.exe",
        "${env:ProgramFiles(x86)}\Slack\slack.exe"
    )
    foreach ($path in $slackPaths) {
        if ($path -and (Test-Path -LiteralPath $path)) { Write-Success "Slack instalado"; return $true }
    }

    Write-Warn "Slack no encontrado. Instalando..."
    return Install-WingetPackage -Id "SlackTechnologies.Slack" -Name "Slack"
}

# ==============================================================================
# 10. INSTALAR OPENCODE
# ==============================================================================
function Install-OpenCode {
    Write-Step "Verificando OpenCode..."

    $opencode = Get-Command opencode -ErrorAction SilentlyContinue
    if ($opencode) { Write-Success "OpenCode instalado"; return $true }

    Write-Warn "OpenCode no encontrado. Instalando..."
    if ($DryRun) { Write-Info "DryRun: npm install -g opencode-ai"; return $true }
    try {
        npm install -g opencode-ai 2>&1 | Out-Null
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Success "OpenCode instalado"
        return $true
    } catch {
        Write-Warn "Error installing OpenCode. Prueba: npm install -g opencode-ai"
        return $false
    }
}

# ==============================================================================
# 11. INSTALAR ENGRAM
# ==============================================================================
function Install-Engram {
    Write-Step "Verificando Engram..."

    $requiredEngramVersion = "1.15.15"
    $engramPath = "$env:LOCALAPPDATA\engram\bin\engram.exe"
    if (Test-Path $engramPath) {
        $version = & $engramPath version 2>$null
        if ($version -match "engram\s+$requiredEngramVersion") {
            Write-Success "Engram instalado: $version"
            return $true
        }
        Write-Warn "Engram requiere actualizacion: $version -> $requiredEngramVersion"
    } else {
        Write-Warn "Engram no encontrado. Instalando..."
    }

    if ($DryRun) { Write-Info "DryRun: se descargaria e instalaria Engram $requiredEngramVersion"; return $true }
    try {
        $engramDir = Split-Path $engramPath -Parent
        if (!(Test-Path $engramDir)) { New-Item -ItemType Directory -Path $engramDir -Force | Out-Null }

        $engramWork = Join-Path ([System.IO.Path]::GetTempPath()) ("engram-install-" + [guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $engramWork -Force | Out-Null
        $engramZip = Join-Path $engramWork "engram.zip"
        $engramExtract = Join-Path $engramWork "extract"
        Invoke-WebRequest -Uri "https://github.com/Gentleman-Programming/engram/releases/download/v$requiredEngramVersion/engram_${requiredEngramVersion}_windows_amd64.zip" -OutFile $engramZip -UseBasicParsing -TimeoutSec 120
        Expand-Archive -Path $engramZip -DestinationPath $engramExtract -Force
        Copy-Item "$engramExtract\engram.exe" -Destination $engramDir -Force
        if ([System.IO.Directory]::Exists($engramWork)) { [System.IO.Directory]::Delete($engramWork, $true) }

        $version = & $engramPath version 2>$null
        Write-Success "Engram instalado: $version"
        return $true
    } catch {
        Write-Fatal "Error installing Engram"
        return $false
    }
}

# ==============================================================================
# 11b. INSTALAR UV (requerido por markitdown-mcp)
# ==============================================================================
function Install-Uv {
    Write-Step "Verificando uv (para markitdown-mcp)..."

    $uv = Get-Command uv -ErrorAction SilentlyContinue
    if ($uv) {
        $version = uv --version 2>&1
        Write-Success "uv instalado: $version"
        return $true
    }

    Write-Warn "uv no encontrado. Instalando..."
    if ($DryRun) { Write-Info "DryRun: irm https://astral.sh/uv/install.ps1 | iex"; return $true }
    try {
        Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") + ";$env:USERPROFILE\.local\bin"
        Write-Success "uv instalado (markitdown-mcp listo para usar)"
        return $true
    } catch {
        Write-Warn "No se pudo instalar uv. markitdown-mcp no funcionara hasta instalarlo: https://docs.astral.sh/uv/"
        return $false
    }
}

# ==============================================================================
# 12. INSTALAR AGENTES GGS
# ==============================================================================
function Get-AgentConfigDir {
    param([Parameter(Mandatory=$true)][string]$TargetAgent)

    switch ($TargetAgent.ToLower()) {
        "opencode" { $ConfigDir = "$env:USERPROFILE\.config\opencode\skills" }
        "claude"   { $ConfigDir = "$env:USERPROFILE\.claude\skills\ggs" }
        "codex"    { $ConfigDir = "$env:USERPROFILE\.codex\skills\ggs" }
        "antigravity" { $ConfigDir = "$env:USERPROFILE\.antigravity\skills\ggs" }
        "cursor"   { $ConfigDir = "$env:USERPROFILE\.cursor\skills\ggs" }
        "windsurf" { $ConfigDir = "$env:USERPROFILE\.windsurf\skills\ggs" }
        default    { Write-Fatal "Agente desconocido: $TargetAgent"; return $null }
    }

    return $ConfigDir
}

function Install-Agents {
    param([string]$TargetAgent = $Agent)

    Write-Step "Instalando Agentes GGS para $TargetAgent..."

    $ConfigDir = Get-AgentConfigDir -TargetAgent $TargetAgent
    if (-not $ConfigDir) { return $false }

    $RepoUrl = "https://github.com/agallardo2802/Proyecto-Agentes"
    $SkillsDir = $ConfigDir
    $ParentDir = Split-Path -Parent $SkillsDir
    $SourceDir = $env:GGS_AGENTS_SOURCE_DIR

    if (!(Test-Path $ParentDir)) { New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null }

    if ($SourceDir -and (Test-Path -LiteralPath (Join-Path $SourceDir "scripts\install.ps1"))) {
        Write-Info "Instalando desde paquete local: $SourceDir"
        if ($DryRun) {
            Write-Info "DryRun: se copiaria $SourceDir a $SkillsDir"
        } else {
            $backupRoot = Join-Path $ParentDir "backups"
            if (!(Test-Path -LiteralPath $backupRoot)) { New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null }
            if (Test-Path -LiteralPath $SkillsDir) {
                $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
                $backupDir = Join-Path $backupRoot ((Split-Path -Leaf $SkillsDir) + ".$timestamp.bak")
                Move-Item -LiteralPath $SkillsDir -Destination $backupDir -Force
                Write-Info "Instalacion anterior movida a backup: $backupDir"
            }
            New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
            $excludeNames = @(".git", ".claude", "node_modules", "dist", "backups", ".next")
            Get-ChildItem -LiteralPath $SourceDir -Force | Where-Object { $excludeNames -notcontains $_.Name } | ForEach-Object {
                Copy-Item -LiteralPath $_.FullName -Destination $SkillsDir -Recurse -Force
            }
        }
    } elseif (Test-Path (Join-Path $SkillsDir ".git")) {
        Write-Info "Actualizando instalacin existente..."
        if ($DryRun) {
            Write-Info "DryRun: se omitio git pull origin main en $SkillsDir"
        } else {
            $PullCommand = 'git -C "{0}" pull origin main >NUL 2>NUL' -f $SkillsDir
            cmd.exe /d /c $PullCommand
            if ($LASTEXITCODE -ne 0) {
                Write-Warn "No se pudo actualizar la instalacion existente en $SkillsDir. Se conserva sin modificar para proteger cambios locales."
            }
        }
    } elseif (!(Test-Path $SkillsDir)) {
        Write-Info "Clonando repositorio de agentes..."
        if ($DryRun) {
            Write-Info "DryRun: se omitio git clone $RepoUrl $SkillsDir"
        } else {
            $CloneCommand = 'git clone "{0}" "{1}" >NUL 2>NUL' -f $RepoUrl, $SkillsDir
            cmd.exe /d /c $CloneCommand
            if ($LASTEXITCODE -ne 0) {
                Write-Fatal "No se pudo clonar $RepoUrl en $SkillsDir"
                return $false
            }
        }
    } else {
        Write-Fatal "El directorio existe pero no es git: $SkillsDir"
        Write-Warn "No se borra automaticamente para proteger skills/config local. Movelo o limpialo manualmente y reintenta."
        return $false
    }

    Write-Success "Agentes GGS instalados en: $SkillsDir"
    return $true
}

# ==============================================================================
# 13. CONFIGURAR OPENCODE - CAPA GGS v2
# ==============================================================================
function Configure-OpenCode {
    Write-Step "Configurando OpenCode con capa GGS v2..."

    $OpenCodeConfig = "$env:USERPROFILE\.config\opencode"
    $OpenCodeJson = Join-Path $OpenCodeConfig "opencode.json"
    $OpenCodeBackupDir = Join-Path $OpenCodeConfig "backups"
    $LegacyBrand = "C" + "4"
    $LegacySdd = "sdd-" + $LegacyBrand.ToLower()
    $LegacyOrchestrator = "Sdd-" + $LegacyBrand + "-Orchestrator"
    $LegacyPlan = "Sdd-" + $LegacyBrand + "-Plan"
    $LegacyJudgment = "Sdd-" + $LegacyBrand + "-Judgment"
    $LegacySkills = "Sdd-" + $LegacyBrand + "-Skills"
    $StaleAgentDirs = @(
        (Join-Path $OpenCodeConfig "agents\sdd-ggs"),
        (Join-Path $OpenCodeConfig "agents\$LegacySdd"),
        (Join-Path $OpenCodeConfig "agents\Sdd-GGS-Orchestrator"),
        (Join-Path $OpenCodeConfig "agents\Sdd-GGS-Plan"),
        (Join-Path $OpenCodeConfig "agents\Sdd-GGS-Judgment"),
        (Join-Path $OpenCodeConfig "agents\Sdd-GGS-Skills"),
        (Join-Path $OpenCodeConfig "agents\$LegacyOrchestrator"),
        (Join-Path $OpenCodeConfig "agents\$LegacyPlan"),
        (Join-Path $OpenCodeConfig "agents\$LegacyJudgment"),
        (Join-Path $OpenCodeConfig "agents\$LegacySkills"),
        (Join-Path $OpenCodeConfig "agents\Orquestador"),
        (Join-Path $OpenCodeConfig "agents\Planificador"),
        (Join-Path $OpenCodeConfig "agents\Revisor"),
        (Join-Path $OpenCodeConfig "agents\custom\sdd-ggs"),
        (Join-Path $OpenCodeConfig "agents\custom\$LegacySdd"),
        (Join-Path $OpenCodeConfig "agents\custom\Sdd-GGS-Orchestrator"),
        (Join-Path $OpenCodeConfig "agents\custom\Sdd-GGS-Plan"),
        (Join-Path $OpenCodeConfig "agents\custom\Sdd-GGS-Judgment"),
        (Join-Path $OpenCodeConfig "agents\custom\Sdd-GGS-Skills"),
        (Join-Path $OpenCodeConfig "agents\custom\$LegacyOrchestrator"),
        (Join-Path $OpenCodeConfig "agents\custom\$LegacyPlan"),
        (Join-Path $OpenCodeConfig "agents\custom\$LegacyJudgment"),
        (Join-Path $OpenCodeConfig "agents\custom\$LegacySkills"),
        (Join-Path $OpenCodeConfig "agents\custom\Orquestador"),
        (Join-Path $OpenCodeConfig "agents\custom\Planificador"),
        (Join-Path $OpenCodeConfig "agents\custom\Revisor")
    )
    foreach ($dir in $StaleAgentDirs) {
        if (Test-Path -LiteralPath $dir) {
            if (-not (Test-Path -LiteralPath $OpenCodeBackupDir)) { New-Item -ItemType Directory -Path $OpenCodeBackupDir -Force | Out-Null }
            $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
            $leaf = Split-Path -Leaf $dir
            $backupDir = Join-Path $OpenCodeBackupDir "$leaf.$timestamp.bak"
            Move-Item -LiteralPath $dir -Destination $backupDir -Force
            Write-Info "Movido agente OpenCode legacy a backup: $backupDir"
        }
    }

    if (!(Test-Path $OpenCodeConfig)) { New-Item -ItemType Directory -Path $OpenCodeConfig -Force | Out-Null }

    function ConvertTo-HashtableCompat {
        param([Parameter(ValueFromPipeline)]$InputObject)
        if ($null -eq $InputObject) { return @{} }
        if ($InputObject -is [hashtable]) { return $InputObject }
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $array = @()
            foreach ($item in $InputObject) { $array += ConvertTo-HashtableCompat $item }
            return $array
        }
        if ($InputObject -is [pscustomobject]) {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-HashtableCompat $property.Value
            }
            return $hash
        }
        return $InputObject
    }

    if (Test-Path $OpenCodeJson) {
        try {
            $config = ConvertTo-HashtableCompat (Get-Content -LiteralPath $OpenCodeJson -Raw | ConvertFrom-Json)
        } catch {
            Write-Fatal "opencode.json no es JSON valido: $OpenCodeJson"
            Write-Warn "No se modifico la configuracion. Corregi el JSON o usa OPENCODE_DISABLE_PROJECT_CONFIG/OPENCODE_CONFIG_CONTENT para recuperar OpenCode."
            return $false
        }
    } else {
        $config = @{}
    }

    $config['$schema'] = "https://opencode.ai/config.json"
    if (-not $config.ContainsKey('agent')) { $config['agent'] = @{} }
    if (-not $config.ContainsKey('mcp')) { $config['mcp'] = @{} }
    if (-not $config.ContainsKey('command')) { $config['command'] = @{} }

    $existingModel = if ($config.ContainsKey('model')) { $config['model'] } else { $null }
    $model = if ($existingModel -and $LegacyOpenCodeDefaultModels -notcontains $existingModel) { $existingModel } else { $DefaultOpenCodeModel }
    if ($model) { $config['model'] = $model } else { $config.Remove('model') | Out-Null }

    $legacyAgentKeys = @(
        'Orquestador',
        'Sdd-GGS-Orchestrator',
        'Sdd-GGS-Plan',
        'Sdd-GGS-Judgment',
        'Sdd-GGS-Skills',
        'sdd-ggs',
        $LegacySdd,
        $LegacyOrchestrator,
        $LegacyPlan,
        $LegacyJudgment,
        $LegacySkills
    )
    $legacyAgentKeys | ForEach-Object { $config['agent'].Remove($_) | Out-Null }

    $arquitecto = @{
        description = "Arquitecto - flujo completo SDD-GGS; orquesta todo el proceso"
        mode = "primary"
        prompt = "{file:./skills/agents/Arquitecto/AGENT.md}"
    }
    $planificador = @{
        description = "Planificador - solo analisis y carga de tablero"
        mode = "primary"
        prompt = "{file:./skills/agents/Planificador/AGENT.md}"
    }
    $revisor = @{
        description = "Revisor - revision adversarial"
        mode = "primary"
        prompt = "{file:./skills/agents/Revisor/AGENT.md}"
    }
    $config['agent']['Arquitecto'] = $arquitecto
    $config['agent']['Planificador'] = $planificador
    $config['agent']['Revisor'] = $revisor

    $profilesDir = Join-Path $OpenCodeConfig "profiles"
    if (-not (Test-Path -LiteralPath $profilesDir)) { New-Item -ItemType Directory -Path $profilesDir -Force | Out-Null }
    function New-SddProfile {
        param(
            [Parameter(Mandatory=$true)][hashtable]$Models,
            [Parameter(Mandatory=$true)][hashtable]$Efforts
        )
        $configs = [ordered]@{}
        foreach ($phase in $Efforts.Keys) {
            $configs[$phase] = [ordered]@{ reasoningEffort = $Efforts[$phase] }
        }
        return [ordered]@{
            models = $Models
            fallback = [ordered]@{}
            configs = $configs
        }
    }

    $fullCodexModels = [ordered]@{
        "gentle-orchestrator" = "openai/gpt-5.5"
        "sdd-apply" = "openai/gpt-5.5"
        "sdd-archive" = "openai/gpt-5.4-mini"
        "sdd-design" = "openai/gpt-5.5"
        "sdd-explore" = "openai/gpt-5.3-codex"
        "sdd-init" = "openai/gpt-5.3-codex"
        "sdd-judgment" = "openai/gpt-5.5"
        "sdd-onboard" = "openai/gpt-5.3-codex"
        "sdd-plan" = "openai/gpt-5.5"
        "sdd-propose" = "openai/gpt-5.5"
        "sdd-spec" = "openai/gpt-5.3-codex"
        "sdd-tasks" = "openai/gpt-5.3-codex"
        "sdd-verify" = "openai/gpt-5.5"
    }
    $enterpriseSafeModels = [ordered]@{
        "gentle-orchestrator" = "google/gemini-3.5-flash"
        "sdd-apply" = "openai/gpt-5.5"
        "sdd-archive" = "google/gemini-3.5-flash"
        "sdd-design" = "openai/gpt-5.5"
        "sdd-explore" = "google/gemini-3.5-flash"
        "sdd-init" = "google/gemini-3.5-flash"
        "sdd-judgment" = "openai/gpt-5.5"
        "sdd-onboard" = "google/gemini-3.5-flash"
        "sdd-plan" = "google/gemini-3.5-flash"
        "sdd-propose" = "google/gemini-3.5-flash"
        "sdd-spec" = "google/gemini-3.5-flash"
        "sdd-tasks" = "openai/gpt-5.5"
        "sdd-verify" = "openai/gpt-5.5"
    }
    $lowCostModels = [ordered]@{
        "gentle-orchestrator" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-apply" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-archive" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-design" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-explore" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-init" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-judgment" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-onboard" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-plan" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-propose" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-spec" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-tasks" = "ggsoluciones-ai/minimax-m2.7"
        "sdd-verify" = "ggsoluciones-ai/minimax-m2.7"
    }
    $standardEfforts = [ordered]@{
        "gentle-orchestrator" = "medium"
        "sdd-apply" = "high"
        "sdd-archive" = "low"
        "sdd-design" = "high"
        "sdd-explore" = "medium"
        "sdd-init" = "low"
        "sdd-judgment" = "high"
        "sdd-onboard" = "low"
        "sdd-plan" = "medium"
        "sdd-propose" = "medium"
        "sdd-spec" = "medium"
        "sdd-tasks" = "medium"
        "sdd-verify" = "high"
    }
    $lowCostEfforts = [ordered]@{
        "gentle-orchestrator" = "medium"
        "sdd-apply" = "medium"
        "sdd-archive" = "low"
        "sdd-design" = "medium"
        "sdd-explore" = "medium"
        "sdd-init" = "low"
        "sdd-judgment" = "medium"
        "sdd-onboard" = "low"
        "sdd-plan" = "medium"
        "sdd-propose" = "medium"
        "sdd-spec" = "medium"
        "sdd-tasks" = "medium"
        "sdd-verify" = "medium"
    }

    $profileDefinitions = [ordered]@{
        "Codex-Ale.json" = New-SddProfile -Models $fullCodexModels -Efforts $standardEfforts
        "Codex-Ale SDD Profile.json" = New-SddProfile -Models $fullCodexModels -Efforts $standardEfforts
        "Full Codex.json" = New-SddProfile -Models $fullCodexModels -Efforts $standardEfforts
        "Enterprise Safe.json" = New-SddProfile -Models $enterpriseSafeModels -Efforts $standardEfforts
        "Low Cost.json" = New-SddProfile -Models $lowCostModels -Efforts $lowCostEfforts
    }

    foreach ($profileName in $profileDefinitions.Keys) {
        $codexProfilePath = Join-Path $profilesDir $profileName
        if ((Test-Path -LiteralPath $codexProfilePath) -and -not $DryRun) {
            Backup-File -Path $codexProfilePath -BackupRoot (Join-Path $OpenCodeConfig "backups") | Out-Null
        }
        if (-not $DryRun) {
            $profileDefinitions[$profileName] | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 -LiteralPath $codexProfilePath
        }
    }    if (-not $DefaultOpenCodeModel) {
        Write-Info "Codex no detectado: OpenCode queda con su modelo por defecto o el modelo existente."
    }

    @($config['agent'].Keys) | Where-Object { $_ -like "*-fallback" -or $_ -in @("sdd-plan", "sdd-judgment", "Sdd-GGS-Skills", $LegacySkills, $LegacySdd) } | ForEach-Object {
        $config['agent'].Remove($_)
    }
    $config['agent']['plan'] = @{ hidden = $true }
    $config['agent']['build'] = @{ hidden = $true }

    $optionalMcpEnabled = ($env:GGS_ENABLE_OPTIONAL_MCPS -eq "1")
    if (-not $config['mcp'].ContainsKey('context7')) {
        $config['mcp']['context7'] = @{
            enabled = $optionalMcpEnabled
            type = "remote"
            url = "https://mcp.context7.com/mcp"
        }
    }
    if (-not $config['mcp'].ContainsKey('engram')) {
        $config['mcp']['engram'] = @{
            type = "local"
            command = @(
                "$env:LOCALAPPDATA\engram\bin\engram.exe",
                "mcp",
                "--tools=agent"
            )
        }
    }

    $config['mcp']['azure-devops'] = @{
        enabled = $optionalMcpEnabled
        type = "local"
        command = @(
            "npx",
            "-y",
            "@azure-devops/mcp",
            "ggsoluciones",
            "-d",
            "core",
            "work",
            "work-items",
            "repositories",
            "wiki",
            "pipelines"
        )
    }
    $config['mcp']['playwright'] = @{
        enabled = $optionalMcpEnabled
        type = "local"
        command = @(
            "npx",
            "-y",
            "@playwright/mcp@latest"
        )
    }
    # Markitdown: convierte PDF/Word/Excel/PPT/imagenes a Markdown para ahorrar tokens.
    # Sin credenciales -> habilitado por defecto (requiere uv/uvx, instalado arriba).
    $config['mcp']['markitdown'] = @{
        enabled = $true
        type = "local"
        command = @(
            "uvx",
            "markitdown-mcp"
        )
    }
    # Notion (oficial): requiere NOTION_TOKEN en el entorno -> opcional.
    $config['mcp']['notion'] = @{
        enabled = $optionalMcpEnabled
        type = "local"
        command = @(
            "npx",
            "-y",
            "@notionhq/notion-mcp-server"
        )
        environment = @{
            NOTION_TOKEN = "{env:NOTION_TOKEN}"
        }
    }
    # NotebookLM: requiere login de browser (auth persistente) -> opcional.
    $config['mcp']['notebooklm'] = @{
        enabled = $optionalMcpEnabled
        type = "local"
        command = @(
            "npx",
            "-y",
            "notebooklm-mcp@latest"
        )
    }

    $installedRoot = "$env:USERPROFILE\.config\opencode\skills"
    $updateScript = Join-Path $installedRoot "scripts\update.ps1"
    $config['command']['ggs-update'] = @{
        description = "Actualizar Gentle AI CLI y agentes GGS, refrescando OpenCode"
        template = "Ejecuta en PowerShell: `& '$updateScript' -ConfigureOpenCode -UpdateGentleAI`. Luego resume version, cambios y si hace falta reiniciar OpenCode."
    }
    $config['command']['ggs-status'] = @{
        description = "Validar instalacion GGS/OpenCode y ofrecer actualizacion segura"
        template = "Ejecuta en PowerShell: `& '$updateScript' -DryRun -ConfigureOpenCode`. Reporta estado de `opencode.json`, Gentle AI y agentes GGS. Si falta actualizar, hay cambios pendientes o detectas configuracion incompleta, pregunta al usuario si quiere continuar con la actualizacion. No avances sin confirmacion explicita. Si confirma, ejecuta: `& '$updateScript' -ConfigureOpenCode -UpdateGentleAI`. Al finalizar, resume cambios, backups creados y recorda reiniciar OpenCode."
    }

    $json = $config | ConvertTo-Json -Depth 10
    try { $null = $json | ConvertFrom-Json } catch { Write-Fatal "El JSON generado para OpenCode no es valido"; return $false }

    if ($DryRun) {
        Write-Info "DryRun: no se escribio $OpenCodeJson"
        Write-Info "DryRun: agentes que quedarian registrados: Arquitecto, Planificador, Revisor"
        return $true
    }

    $backup = Backup-File -Path $OpenCodeJson -BackupRoot (Join-Path $OpenCodeConfig "backups")
    if ($backup) { Write-Info "Backup creado: $backup" }
    $json | Set-Content -Path $OpenCodeJson -Encoding UTF8
    Install-OpenCodeLogoPlugin | Out-Null
    Write-Success "OpenCode configurado con capa GGS sin pisar proveedor/modelo existente"
    return $true
}

function Install-OpenCodeLogoPlugin {
    Write-Step "Instalando logo GGSoluciones para OpenCode..."

    $pluginDir = "$env:USERPROFILE\.config\opencode\tui-plugins"
    $pluginPath = Join-Path $pluginDir "gentle-logo.tsx"
    $pluginContent = @'
// @ts-nocheck
/** @jsxImportSource @opentui/solid */
import type { TuiPlugin, TuiThemeCurrent } from "@opencode-ai/plugin/tui"
import { useTerminalDimensions } from "@opentui/solid"
import { createMemo } from "solid-js"

const id = "gentle-logo"

const ggsArt = [
  "██████████              ██████████",
  "  ████████████████        ████████████████",
  " █████        █████      █████        █████",
  " ████                    ████",
  " ████                    ████",
  " ████       ████████     ████       ████████",
  " ████       ████████     ████       ████████",
  " ████         █████      ████         █████",
  "  ████████████████        ████████████████",
  "    ██████████              ██████████",
  "   S  O  L  U  C  I  O  N  E  S",
]

const compactArt = [" GGSoluciones AI"]

const Logo = (props: { theme: TuiThemeCurrent }) => {
  const dim = useTerminalDimensions()
  const lines = createMemo(() => {
    const term = dim()
    return term.height >= ggsArt.length + 6 && term.width >= 76 ? ggsArt : compactArt
  })

  return (
    <box flexDirection="column" alignItems="center">
      {lines().map((line) => (
        <text fg="#E30613">{line}</text>
      ))}
    </box>
  )
}

const tui: TuiPlugin = async (api) => {
  api.slots.register({
    id,
    order: 100,
    slots: {
      home_logo(ctx) {
        return <Logo theme={ctx.theme.current} />
      },
    },
  })
}

const plugin = { id: "gentle-logo", tui }
export default plugin
'@

    if ($DryRun) {
        Write-Info "DryRun: se escribiria $pluginPath"
        return $true
    }

    if (!(Test-Path $pluginDir)) { New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null }
    if (Test-Path $pluginPath) { Backup-File -Path $pluginPath -BackupRoot (Join-Path "$env:USERPROFILE\.config\opencode" "backups") | Out-Null }
    $pluginContent | Set-Content -LiteralPath $pluginPath -Encoding UTF8
    Write-Success "Logo GGSoluciones instalado en: $pluginPath"
    return $true
}

# ==============================================================================
# EJECUCIN PRINCIPAL
# ==============================================================================

Write-Host ""

$results = @{}

if ($DryRun) {
    Write-Warn "Modo DryRun: se mostraran acciones sin clonar, actualizar ni escribir opencode.json."
}

if ($UpdateGentleAI) {
    $results.GentleAI = Install-GentleAI
}

if ($ConfigureOpenCodeOnly) {
    if ($Agent.ToLower() -ne "opencode") { Write-Fatal "-ConfigureOpenCodeOnly solo aplica con -Agent opencode"; exit 1 }
    $results.OpenCodeConfig = Configure-OpenCode
    if ($results.OpenCodeConfig) { return } else { throw "No se pudo configurar OpenCode" }
}

Write-Host " 1. HERRAMIENTAS BASE " -ForegroundColor Cyan
Write-Host ""

if (!$SkipPrerequisites) {
    $results.Git = Install-Git
    $results.Python = Install-Python
    $results.NodeJS = Install-NodeJS
    $results.Go = Install-Go
    $results.DotNet = Install-DotNet
    $results.Docker = Install-Docker
    $results.Terminal = Install-Terminal
    $results.VSCode = Install-VSCode
    $results.Slack = Install-Slack

    Write-Host ""
    Write-Host " 2. HERRAMIENTAS IA " -ForegroundColor Cyan
    Write-Host ""

    $results.OpenCode = Install-OpenCode
    $results.Engram = Install-Engram
    $results.Uv = Install-Uv
}

if ($OnlyPrerequisites) {
    Write-Host ""
    Write-Host "" -ForegroundColor Green
    Write-Host "   Instalacin de herramientas completada!" -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host " 3. AGENTES GGS " -ForegroundColor Cyan
Write-Host ""

$results.Agents = Install-Agents -TargetAgent $Agent
if (-not $results.Agents) {
    Write-Fatal "No se pudo instalar/actualizar la distribucin GGS. No se modificar opencode.json."
} elseif ($Agent.ToLower() -eq "opencode" -and -not $NoConfigureOpenCode) {
    $results.OpenCodeConfig = Configure-OpenCode
} elseif ($Agent.ToLower() -eq "opencode" -and $NoConfigureOpenCode) {
    Write-Warn "Se omitio configuracion de OpenCode por -NoConfigureOpenCode"
}

if ($Agent.ToLower() -eq "opencode" -and -not $NoInstallCompanionAgents) {
    if (-not $NoInstallClaude) {
        $results.ClaudeSkills = Install-Agents -TargetAgent "claude"
    }
    $results.CodexSkills = Install-Agents -TargetAgent "codex"
    $results.AntigravitySkills = Install-Agents -TargetAgent "antigravity"
}


# ==============================================================================
# RESUMEN FINAL
# ==============================================================================
Write-Host ""
Write-Host "" -ForegroundColor Magenta
Write-Host "  RESUMEN DE INSTALACIN" -ForegroundColor Magenta
Write-Host "" -ForegroundColor Magenta
Write-Host ""

$failed = @()
foreach ($key in $results.Keys) {
    if ($results[$key]) { Write-Success "$key" } else { Write-Fatal "$key"; $failed += $key }
}

Write-Host ""
if ($failed.Count -eq 0) {
    Write-Host "" -ForegroundColor Green
    Write-Host "   TODO INSTALADO CORRECTAMENTE!" -ForegroundColor Green
    Write-Host "" -ForegroundColor Green
} else {
    Write-Host "" -ForegroundColor Yellow
    Write-Host "   Elementos que requieren atencin manual:" -ForegroundColor Yellow
    $failed | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }
    Write-Host "" -ForegroundColor Yellow
}

Write-Host ""
Write-Host " PRXIMOS PASOS " -ForegroundColor Cyan
Write-Host ""
if ($Agent.ToLower() -eq "opencode") {
    Write-Host "  1. Reinicia tu terminal (cierra y abre nuevamente)" -ForegroundColor White
    Write-Host "  2. Ejecuta: opencode" -ForegroundColor White
    Write-Host "  3. Selecciona 'Arquitecto', 'Planificador' o 'Revisor' del dropdown" -ForegroundColor White
    Write-Host "  4. Escribe 'sdd' para iniciar el flujo SDD" -ForegroundColor White
    if (-not $NoInstallCompanionAgents) {
        Write-Host "  5. Reinicia los companion agents instalados: Claude Code si no usaste -NoInstallClaude, Codex y Antigravity" -ForegroundColor White
    }
} else {
    Write-Host "  1. Reinicia tu cliente AI si estaba abierto" -ForegroundColor White
    Write-Host "  2. Verifica que cargue skills desde: $($Agent.ToLower())" -ForegroundColor White
    Write-Host "  3. Usa las skills GGS por contexto: login-web, reportes-ggs, chatbot-web, etc." -ForegroundColor White
}
Write-Host ""
