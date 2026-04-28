# GGS Agents Installer v3.0 - TUI Interactive + Auto-Dependencies
# Usage: .\install.ps1 [-Agent opencode|claude|cursor] [-RepoUrl <url>] [-SkipInstall]

param(
    [string]$Agent = "opencode",
    [string]$RepoUrl = "https://github.com/agallardo2802/Proyecto-Agentes.git",
    [switch]$SkipInstall
)

# ============================================
# COLORS
# ============================================
$Colors = @{
    Red = "#FF6B6B"
    Green = "#51CF66"
    Cyan = "#22B8CF"
    Yellow = "#FCC419"
    Gray = "#868E96"
    Purple = "#845EF7"
    White = "#FFFFFF"
    Background = "#1E1E2E"
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

function Write-Banner {
    param([string]$Text)
    $width = 60
    $padding = " " * (([math]::Max(0, $width - $Text.Length) / 2))
    Write-Host ""
    Write-Host "$padding$Text" -ForegroundColor Cyan
    Write-Host ""
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Get-VersionSafe {
    param([string]$Command)
    try {
        $version = & $Command --version 2>$null | Select-Object -First 1
        if ($version -match '\d+\.\d+') { $version -match '(\d+\.\d+)' | Out-Null; $Matches[1] }
        else { $version }
    } catch { "Not found" }
}

# ============================================
# DEPENDENCY DETECTION
# ============================================

function Get-Dependencies {
    Write-Host ""
    Write-Host "🔍 Detecting dependencies..." -ForegroundColor Cyan
    
    $deps = @{}
    
    # Git
    $deps.git = @{
        name = "Git"
        command = "git"
        required = $true
        install = "winget install Git.Git --accept-source-agreements --accept-package-agreements"
        minVersion = "2.30"
    }
    if (Test-CommandExists "git") {
        $version = git --version 2>$null
        if ($version -match '\d+\.\d+') { $deps.git.version = $Matches[0] }
        $deps.git.installed = $true
    }
    
    # Go
    $deps.go = @{
        name = "Go"
        command = "go"
        required = $false
        install = "winget install GoLang.Go.1.24"
        minVersion = "1.21"
    }
    if (Test-CommandExists "go") {
        $version = go version 2>$null
        if ($version -match 'go(\d+\.\d+)') { $deps.go.version = $Matches[1] }
        $deps.go.installed = $true
    }
    
    # Python
    $deps.python = @{
        name = "Python"
        command = "python"
        required = $false
        install = "winget install Python.Python.3.12"
        minVersion = "3.10"
    }
    if (Test-CommandExists "python") {
        $version = python --version 2>$null
        if ($version -match '(\d+\.\d+)') { $deps.python.version = $Matches[1] }
        $deps.python.installed = $true
    }
    
    # Node.js
    $deps.node = @{
        name = "Node.js"
        command = "node"
        required = $true
        install = "winget install OpenJS.NodeJS.LTS"
        minVersion = "18"
    }
    if (Test-CommandExists "node") {
        $version = node --version 2>$null
        if ($version -match 'v(\d+)') { $deps.node.version = $Matches[1] }
        $deps.node.installed = $true
    }
    
    # NPM
    $deps.npm = @{
        name = "NPM"
        command = "npm"
        required = $true
        install = "Included with Node.js"
        minVersion = "8"
    }
    if (Test-CommandExists "npm") {
        $version = npm --version 2>$null
        $deps.npm.version = $version
        $deps.npm.installed = $true
    }
    
    # OpenCode
    $deps.opencode = @{
        name = "OpenCode"
        command = "opencode"
        required = $true
        install = "Download from https://opencode.ai"
        minVersion = "1.0"
    }
    if (Test-CommandExists "opencode") {
        $version = opencode --version 2>$null
        $deps.opencode.version = $version
        $deps.opencode.installed = $true
    }
    
    # Engram
    $deps.engram = @{
        name = "Engram"
        command = "engram"
        required = $false
        install = "go install github.com/gentleman-programming/engram/cmd/engram@latest"
        minVersion = "1.0"
    }
    if (Test-CommandExists "engram") {
        $version = engram --version 2>$null
        $deps.engram.version = $version
        $deps.engram.installed = $true
    }
    
    return $deps
}

function Show-DependencyTable {
    param($deps)
    
    Write-Host ""
    Write-Host "📦 Dependency Status:" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Gray
    
    foreach ($key in $deps.Keys | Sort-Object) {
        $dep = $deps[$key]
        $status = if ($dep.installed) { "✅" } else { "❌" }
        $version = if ($dep.version) { "v$($dep.version)" } else { "" }
        
        $line = "  $status $($dep.name.PadRight(12)) $version"
        if (-not $dep.installed -and $dep.required) {
            Write-Host $line -ForegroundColor Red
        } elseif (-not $dep.installed) {
            Write-Host $line -ForegroundColor Yellow
        } else {
            Write-Host $line -ForegroundColor Green
        }
    }
}

function Install-MissingDependencies {
    param($deps)
    
    Write-Host ""
    Write-Host "🔧 Installing missing dependencies..." -ForegroundColor Cyan
    
    $toInstall = $deps.Values | Where-Object { -not $_.installed -and $_.required }
    
    if ($toInstall.Count -eq 0) {
        Write-Host "  ✅ All required dependencies already installed" -ForegroundColor Green
        return
    }
    
    foreach ($dep in $toInstall) {
        Write-Host "  📥 Installing $($dep.name)..." -ForegroundColor Yellow
        
        if ($dep.command -eq "opencode") {
            Write-Host "     → Manual download required: https://opencode.ai" -ForegroundColor Yellow
        } else {
            try {
                # Try winget first
                if (Test-CommandExists "winget") {
                    $result = Invoke-Expression $dep.install 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "     ✅ Installed via winget" -ForegroundColor Green
                    }
                }
            } catch {
                Write-Host "     ⚠️ Manual install required: $($dep.install)" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
    Write-Host "⚠️ Please restart PowerShell after installing dependencies" -ForegroundColor Yellow
}

# ============================================
# AGENT SELECTION
# ============================================

function Show-AgentSelector {
    Write-Host ""
    Write-Host "🤖 Select AI Agent(s):" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Gray
    Write-Host "  1. opencode  (Default - Multi-model per phase)"
    Write-Host "  2. claude    (Claude Code - Sub-agents)"
    Write-Host "  3. cursor    (Cursor IDE - Native sub-agents)"
    Write-Host "  4. windsurf  (Windsurf - Plan/Code modes)"
    Write-Host "  5. all       (All supported agents)"
    Write-Host ""
    
    $selection = Read-Host "Select [1-5] or press Enter for opencode"
    
    switch ($selection) {
        "1" { return @("opencode") }
        "2" { return @("claude") }
        "3" { return @("cursor") }
        "4" { return @("windsurf") }
        "5" { return @("opencode", "claude", "cursor", "windsurf") }
        "" { return @("opencode") }
        default { return @("opencode") }
    }
}

function Show-InstallWizard {
    Write-Host ""
    Write-Host "🔧 GGS Agents Install Wizard v3.0" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Gray
    
    # Step 1: Deps
    $deps = Get-Dependencies
    Show-DependencyTable $deps
    
    # Step 2: Install missing
    if (-not $SkipInstall) {
        $missing = $deps.Values | Where-Object { -not $_.installed }
        if ($missing) {
            $install = Read-Host "Install missing dependencies? [y/N]"
            if ($install -eq "y" -or $install -eq "Y") {
                Install-MissingDependencies $deps
            }
        }
    }
    
    # Step 3: Select agent
    $agents = Show-AgentSelector
    
    # Step 4: Confirm
    Write-Host ""
    Write-Host "📋 Installation Summary:" -ForegroundColor Cyan
    Write-Host "  Agents: $($agents -join ', ')"
    Write-Host "  Repo: $RepoUrl"
    Write-Host ""
    
    $confirm = Read-Host "Proceed with installation? [Y/n]"
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    return $agents
}

# ============================================
# MAIN INSTALL LOGIC
# ============================================

function Install-GgsAgents {
    param(
        [string[]]$Agents,
        [string]$RepoUrl
    )
    
    Write-Banner "GGS Agents v3.0"
    
    foreach ($Agent in $Agents) {
        Write-Host ""
        Write-Host "📦 Installing for: $Agent" -ForegroundColor Cyan
        
        # Determine config directory
        $ConfigDir = switch ($Agent.ToLower()) {
            "opencode" { "$env:USERPROFILE\.config\opencode\skills" }
            "claude"   { "$env:USERPROFILE\.claude\skills" }
            "cursor"   { "$env:USERPROFILE\.cursor\skills" }
            "windsurf" { "$env:USERPROFILE\.windsurf\skills" }
            default    { "$env:USERPROFILE\.config\opencode\skills" }
        }
        
        Write-Host "  Config dir: $ConfigDir" -ForegroundColor Gray
        
        # Create directory
        if (!(Test-Path $ConfigDir)) {
            New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
        }
        
        $SkillsDir = Join-Path $ConfigDir "ggs"
        
        # Clone or update
        if (Test-Path $SkillsDir) {
            Write-Host "  📥 Updating..." -ForegroundColor Yellow
            Set-Location $SkillsDir
            git pull origin main 2>$null
        } else {
            Write-Host "  📥 Cloning..." -ForegroundColor Yellow
            git clone $RepoUrl $SkillsDir
        }
        
        # Copy skill to root
        $RootSkillDir = Join-Path $ConfigDir "sdd-ggs"
        if (!(Test-Path $RootSkillDir)) {
            New-Item -ItemType Directory -Path $RootSkillDir -Force | Out-Null
        }
        Copy-Item -Path (Join-Path $SkillsDir "equipo\sdd-ggs\SKILL.md") -Destination (Join-Path $RootSkillDir "SKILL.md") -Force
        
        # Register in OpenCode
        if ($Agent.ToLower() -eq "opencode") {
            Write-Host "  �� Registering in OpenCode..." -ForegroundColor Cyan
            
            $OpenCodeConfig = "$env:USERPROFILE\.config\opencode"
            $OpenCodeJson = Join-Path $OpenCodeConfig "opencode.json"
            
            # Clean old custom agents
            $CustomAgentsDir = Join-Path $OpenCodeConfig "agents\custom"
            @("sdd-ggs", "Sdd-GGS-Orchestrator", "Sdd-GGS-Skills", "Sdd-GGS-Plan", "Sdd-GGS-Judgment") | ForEach-Object {
                $path = Join-Path $CustomAgentsDir $_
                if (Test-Path $path) {
                    Remove-Item -Recurse -Force $path
                }
            }
            
            # Register agents
            if (Test-Path $OpenCodeJson) {
                $json = Get-Content $OpenCodeJson -Raw | ConvertFrom-Json
                
                $commonTools = @{
                    read = $true; edit = $true; write = $true
                    bash = $true; glob = $true; grep = $true
                }
                $model = "opencode/minimax-m2.5-free"
                
                # Sdd-GGS-Orchestrator
                $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Orchestrator" -NotePropertyValue @{
                    name = "Sdd-GGS-Orchestrator"
                    description = "SDD automático - flujo completo con validación"
                    mode = "primary"
                    model = $model
                    prompt = "{file:./skills/ggs/agents/Sdd-GGS-Orchestrator/agent.md}"
                    tools = $commonTools
                } -Force
                
                # Sdd-GGS-Plan
                $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Plan" -NotePropertyValue @{
                    name = "Sdd-GGS-Plan"
                    description = "Plan - solo análisis, sin código"
                    mode = "primary"
                    model = $model
                    prompt = "{file:./skills/ggs/agents/Sdd-GGS-Plan/agent.md}"
                    tools = $commonTools
                } -Force
                
                # Sdd-GGS-Skills
                $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Skills" -NotePropertyValue @{
                    name = "Sdd-GGS-Skills"
                    description = "Skills - control manual por fase"
                    mode = "primary"
                    model = $model
                    prompt = "{file:./skills/ggs/agents/Sdd-GGS-Skills/agent.md}"
                    tools = $commonTools
                } -Force
                
                # Sdd-GGS-Judgment
                $json.agent | Add-Member -NotePropertyName "Sdd-GGS-Judgment" -NotePropertyValue @{
                    name = "Sdd-GGS-Judgment"
                    description = "Judgment Day - revisión adversarial"
                    mode = "primary"
                    model = $model
                    prompt = "{file:./skills/ggs/agents/Sdd-GGS-Judgment/agent.md}"
                    tools = $commonTools
                } -Force
                
                $json | ConvertTo-Json -Depth 10 | Set-Content -Path $OpenCodeJson
                Write-Host "  ✅ Registered 4 agents in OpenCode" -ForegroundColor Green
            }
        }
        
        Write-Host "  ✅ $Agent ready!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Banner "Installation Complete!"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "  1. Open $Agent" -ForegroundColor Gray
    Write-Host "  2. Select 'Sdd-GGS-Orchestrator' from dropdown" -ForegroundColor Gray
    Write-Host "  3. Run: /sdd-init" -ForegroundColor Gray
    Write-Host ""
}

# ============================================
# RUN
# ============================================

$selectedAgents = Show-InstallWizard
Install-GgsAgents -Agents $selectedAgents -RepoUrl $RepoUrl