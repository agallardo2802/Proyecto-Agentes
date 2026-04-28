package tui

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"

	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// Screen represents TUI screens
type Screen int

const (
	ScreenMainMenu Screen = iota
	ScreenInstallMenu      // elegir instalar todos o seleccionar
	ScreenInstallSelect // seleccionar plataformas específicas
	ScreenChangelog    // mostrar changelog antes de instalar
	ScreenInstallURL   // legacy - ya no se usa para opencode
	ScreenInstallProgress
	ScreenInstallDone
	ScreenUninstallMenu  // NEW: seleccionar plataformas para desinstalar
	ScreenUninstallProgress
	ScreenAgentTree
	ScreenAgentView
)

// Styles
var (
	menuStyle      = lipgloss.NewStyle().Foreground(lipgloss.Color("white")).Background(lipgloss.Color("blue")).Padding(1, 2)
	itemStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("white"))
	selectedStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("black")).Background(lipgloss.Color("green")).Padding(0, 1)
	titleStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("cyan")).Bold(true)
	errorStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("red"))
	dimStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	inputStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("yellow")).Background(lipgloss.Color("black"))
	successStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("green"))
)

// State holds all application state
type State struct {
	Screen Screen

	// Menu
	MenuSelected int

	// Install
	RepoURL      string
	InputText   string
	CursorPos   int
	InstallLog  []string
	CloneError  string
	CloneDone   bool
	InstallChoice int  // 0=menu, 1=default, 2=custom
	PlatformTree []platformInfo // Plataformas detectadas
	PlatformCursor int // Cursor para navegar menu de plataformas
	SelectedPlatforms map[string]bool // Plataformas seleccionadas
	InstallMode int // 0=menu principal, 1=todos, 2=seleccionar individually
	CurrentVersion string // Version actual instalada
	RemoteVersion string // Version remota (del repo)
	Changelog string // Cambios entre versiones
	PlatformToInstall string // Plataforma seleccionada para changelog
	ForceInstall bool // Forzar instalación sin verificar cambios

	// Agent tree
	Agents        []AgentItem
	AgentCursor  int
	SelectedAgent string
	MaxLines     int  // Cuantas lineas mostrar

	// Form
	FormInput string
	FormType string
}

// Platform represents an AI coding platform
type Platform struct {
	Name    string
	SkillDir string // Where skills would be installed
	CheckParent string // Parent directory to check if platform exists
}

var platforms = []Platform{
	{Name: "OpenCode", SkillDir: ".config/opencode/skills", CheckParent: ".config/opencode"},
	{Name: "Claude", SkillDir: ".claude/skills", CheckParent: ".claude"},
	{Name: "Cursor", SkillDir: ".cursor/skills", CheckParent: ".cursor"},
	{Name: "Codex", SkillDir: ".codex/skills", CheckParent: ".codex"},
}

	// AgentItem represents a node in the agent tree
type AgentItem struct {
	Name    string
	Path   string
	IsDir  bool
	Indent int
}

// Model implements tea.Model
type Model struct {
	State State
}

// loadAgentTree carga el árbol real de agentes desde el filesystem
func (s *State) loadAgentTree() {
	basePath := "D:/workspace/elcuatro/projects/elcuatro-agentes"
	dirs := []string{"agents", "guilds", "reglas", "templates"}

	s.Agents = []AgentItem{}

	for _, dir := range dirs {
		// Agregar carpeta padre
		s.Agents = append(s.Agents, AgentItem{
			Name:    dir,
			Path:    dir + "/",
			IsDir:   true,
			Indent: 0,
		})

		// Leer archivos en la carpeta
		items, err := os.ReadDir(basePath + "/" + dir)
		if err != nil {
			continue
		}

		for _, item := range items {
			if item.IsDir() {
				// Agregar subcarpeta
				s.Agents = append(s.Agents, AgentItem{
					Name:    "  " + item.Name(),
					Path:    dir + "/" + item.Name() + "/",
					IsDir:   true,
					Indent: 1,
				})

				// Leer archivos dentro de la subcarpeta
				subItems, _ := os.ReadDir(basePath + "/" + dir + "/" + item.Name())
				for _, subItem := range subItems {
					if strings.HasSuffix(subItem.Name(), ".md") {
						s.Agents = append(s.Agents, AgentItem{
							Name:    "    " + subItem.Name(),
							Path:    dir + "/" + item.Name() + "/" + subItem.Name(),
							IsDir:   false,
							Indent: 2,
						})
					}
				}
			} else if strings.HasSuffix(item.Name(), ".md") {
				// Archivo directo en la carpeta
				s.Agents = append(s.Agents, AgentItem{
					Name:    "  " + item.Name(),
					Path:    dir + "/" + item.Name(),
					IsDir:   false,
					Indent: 1,
				})
			}
		}
	}
}

// New creates the model
func New() Model {
	return Model{
		State: State{
			Screen:       ScreenMainMenu,
			MenuSelected: 0,
			Agents: []AgentItem{
				{Name: "agents", Path: "agents/", IsDir: true, Indent: 0},
				{Name: "  Sdd-C4-Orchestrator", Path: "agents/Sdd-C4-Orchestrator/AGENT.md", IsDir: false, Indent: 1},
				{Name: "  Sdd-C4-Skills", Path: "agents/Sdd-C4-Skills/AGENT.md", IsDir: false, Indent: 1},
				{Name: "  Sdd-C4-Plan", Path: "agents/Sdd-C4-Plan/AGENT.md", IsDir: false, Indent: 1},
				{Name: "guilds", Path: "guilds/", IsDir: true, Indent: 0},
				{Name: "  backend-dotnet", Path: "guilds/backend-dotnet/AGENT.md", IsDir: false, Indent: 1},
				{Name: "  frontend-react-nextjs", Path: "guilds/frontend-react-nextjs/AGENT.md", IsDir: false, Indent: 1},
				{Name: "reglas", Path: "reglas/", IsDir: true, Indent: 0},
				{Name: "  code-review", Path: "reglas/code-review/AGENT.md", IsDir: false, Indent: 1},
				{Name: "  debugging", Path: "reglas/debugging/AGENT.md", IsDir: false, Indent: 1},
			},
		},
	}
}

// Init implements tea.Model
func (m Model) Init() tea.Cmd {
	return nil
}

// Update implements tea.Model - handles all events
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	s := &m.State

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit

		case "esc":
			s.goBack()

		case "up", "k":
			s.handleUp()

		case "down", "j":
			s.handleDown()

		case "enter":
			s.handleEnter()

		case "m":
			// Ver mas contenido (aumentar lineas mostradas)
			if s.Screen == ScreenAgentView {
				s.MaxLines += 50
			}

		case "backspace":
			if s.Screen == ScreenInstallURL {
				s.handleBackspace()
			}

		case "c":
			// Confirm selection and show changelog
			if s.Screen == ScreenInstallSelect {
				s.showChangelog()
			}
			if s.Screen == ScreenUninstallMenu {
				s.doUninstall()
			}

		default:
			// Handle text input on install screen
			if s.Screen == ScreenInstallURL {
				s.handleInput(msg.String())
			}
		}

	case tea.WindowSizeMsg:
		// Handle window resize
	}

	return m, nil
}

func (s *State) goBack() {
	switch s.Screen {
	case ScreenInstallMenu, ScreenInstallSelect, ScreenInstallURL, ScreenInstallProgress, ScreenInstallDone, ScreenChangelog, ScreenUninstallMenu, ScreenUninstallProgress:
		s.Screen = ScreenMainMenu
		s.InputText = ""
		s.CursorPos = 0
		s.CloneDone = false
		s.InstallChoice = 0
		s.InstallMode = 0
		s.ForceInstall = false
	case ScreenAgentTree, ScreenAgentView:
		s.Screen = ScreenMainMenu
	}
	s.MenuSelected = 0
}

func (s *State) handleUp() {
	switch s.Screen {
	case ScreenMainMenu:
		if s.MenuSelected > 0 {
			s.MenuSelected--
		}
	case ScreenInstallMenu:
		if s.InstallMode > 0 {
			s.InstallMode--
		}
	case ScreenInstallSelect:
		if s.PlatformCursor > 0 {
			s.PlatformCursor--
		}
	case ScreenInstallURL:
		if s.InstallChoice == 2 { // Custom URL input
			// do nothing in input mode
		} else if s.InstallChoice > 0 {
			s.InstallChoice--
		}
case ScreenAgentTree:
		if s.AgentCursor > 0 {
			s.AgentCursor--
		}
	}
}

func (s *State) handleDown() {
	switch s.Screen {
	case ScreenMainMenu:
		if s.MenuSelected < 2 {
			s.MenuSelected++
		}
	case ScreenInstallMenu:
		if s.InstallMode < 3 {
			s.InstallMode++
		}
	case ScreenInstallSelect:
		if s.PlatformCursor < len(s.PlatformTree)-1 {
			s.PlatformCursor++
		}
	case ScreenInstallURL:
		if s.InstallChoice == 2 {
			// do nothing in input mode
		} else if s.InstallChoice < 2 {
			s.InstallChoice++
		}
	case ScreenAgentTree:
		if s.AgentCursor < len(s.Agents)-1 {
			s.AgentCursor++
		}
	}
}

func (s *State) handleEnter() {
	switch s.Screen {
	case ScreenMainMenu:
		switch s.MenuSelected {
		case 0:
			// Detectar plataformas y mostrar menu
			s.PlatformTree = s.detectAndBuildTree()
			s.PlatformCursor = 0
			s.SelectedPlatforms = make(map[string]bool)
			// Por defecto, seleccionar todas las activas
			for _, p := range s.PlatformTree {
				if p.Active {
					s.SelectedPlatforms[p.Name] = true
				}
			}
			s.Screen = ScreenInstallMenu
			s.InputText = ""
			s.CursorPos = 0
			s.InstallMode = 0
		case 1:
			s.Screen = ScreenAgentTree
			s.loadAgentTree()
		case 2:
			// Uninstall - detect platforms and show menu
			s.PlatformTree = s.detectAndBuildTree()
			s.PlatformCursor = 0
			s.SelectedPlatforms = make(map[string]bool)
			// Select all active by default
			for _, p := range s.PlatformTree {
				if p.Active {
					s.SelectedPlatforms[p.Name] = true
				}
			}
			s.Screen = ScreenUninstallMenu
		}
	case ScreenInstallMenu:
		// 0=Todos, 1=Seleccionar, 2=URL custom, 3=Force install
		if s.InstallMode == 0 {
			s.ForceInstall = false
			s.RepoURL = ""
			s.Screen = ScreenInstallProgress
			s.doClone()
		} else if s.InstallMode == 1 {
			s.PlatformCursor = 0
			s.Screen = ScreenInstallSelect
		} else if s.InstallMode == 2 {
			s.Screen = ScreenInstallURL
		} else if s.InstallMode == 3 {
			s.ForceInstall = true
			s.RepoURL = ""
			s.Screen = ScreenInstallProgress
			s.doClone()
		}
	case ScreenInstallSelect:
		// Toggle selection with space, confirm with Enter
		idx := s.PlatformCursor
		if idx >= 0 && idx < len(s.PlatformTree) {
			p := s.PlatformTree[idx]
			if p.Active {
				if s.SelectedPlatforms[p.Name] {
					s.SelectedPlatforms[p.Name] = false
				} else {
					s.SelectedPlatforms[p.Name] = true
				}
			}
		}
	case ScreenUninstallMenu:
		// Same toggle as install select
		idx := s.PlatformCursor
		if idx >= 0 && idx < len(s.PlatformTree) {
			p := s.PlatformTree[idx]
			if p.Active {
				if s.SelectedPlatforms[p.Name] {
					s.SelectedPlatforms[p.Name] = false
				} else {
					s.SelectedPlatforms[p.Name] = true
				}
			}
		}
	case ScreenInstallURL:
		if s.InstallChoice == 0 {
			// navegar opciones
		} else if s.InstallChoice == 1 {
			s.RepoURL = ""
			s.Screen = ScreenInstallProgress
			s.doClone()
		} else if s.InstallChoice == 2 {
			if s.InputText != "" {
				s.RepoURL = s.InputText
				s.Screen = ScreenInstallProgress
				s.doClone()
			}
		}
	case ScreenInstallDone:
		s.Screen = ScreenMainMenu
	case ScreenChangelog:
		// Confirm and install
		s.RepoURL = ""
		s.Screen = ScreenInstallProgress
		s.doClone()
	case ScreenAgentTree:
		if s.AgentCursor < len(s.Agents) {
			item := s.Agents[s.AgentCursor]
			if !item.IsDir {
				s.SelectedAgent = item.Path
				s.MaxLines = 50
				s.Screen = ScreenAgentView
			}
		}
	}
}

func (s *State) handleBackspace() {
	if s.Screen == ScreenInstallURL && s.CursorPos > 0 {
		s.InputText = s.InputText[:s.CursorPos-1] + s.InputText[s.CursorPos:]
		s.CursorPos--
	}
}

func (s *State) handleInput(key string) {
	if len(key) == 1 {
		s.InputText = s.InputText[:s.CursorPos] + key + s.InputText[s.CursorPos:]
		s.CursorPos++
	}
}

func (s *State) doClone() {
	s.InstallLog = append(s.InstallLog, "")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, " INSTALANDO AGENTES")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, "")

	repoURL := s.RepoURL
	if repoURL == "" {
		repoURL = "https://dev.azure.com/elcuatro/Proyectos%20IT/_git/elcuatro-agentes"
	}

	parts := strings.Split(repoURL, "/")
	repoName := parts[len(parts)-1]
	if strings.HasSuffix(repoName, ".git") {
		repoName = strings.TrimSuffix(repoName, ".git")
	}

	s.InstallLog = append(s.InstallLog, "[10%] Analizando URL...")
	s.InstallLog = append(s.InstallLog, "     "+repoName)

	// Use platforms from state (already detected in handleEnter)
	// s.PlatformTree contains all detected platforms
	s.InstallLog = append(s.InstallLog, "[20%] Plataformas a instalar:")
	selectedCount := 0
	for _, p := range s.PlatformTree {
		if p.Active && s.SelectedPlatforms[p.Name] {
			s.InstallLog = append(s.InstallLog, "     [+] "+p.Name+": "+p.SkillDir)
			selectedCount++
		} else if p.Active {
			s.InstallLog = append(s.InstallLog, "     [-] "+p.Name+": no seleccionado")
		} else {
			s.InstallLog = append(s.InstallLog, "     [-] "+p.Name+": no detectado")
		}
	}

	if selectedCount == 0 {
		s.InstallLog = append(s.InstallLog, "")
		s.InstallLog = append(s.InstallLog, "ERROR: No hay plataformas seleccionadas.")
		s.InstallLog = append(s.InstallLog, "")
		s.InstallLog = append(s.InstallLog, "Para instalar necesitas:")
		s.InstallLog = append(s.InstallLog, " - OpenCode: https://opencode.ai")
		s.InstallLog = append(s.InstallLog, " - Claude:   https://claude.ai (Claude Code)")
		s.InstallLog = append(s.InstallLog, " - Cursor:   https://cursor.sh")
		s.CloneError = "no platforms selected"
		s.Screen = ScreenInstallDone
		return
	}

	// Clone to temp
	tempDir := s.getTempDir()
	s.InstallLog = append(s.InstallLog, "[30%] Preparando instalacion en temp...")
	s.InstallLog = append(s.InstallLog, "     "+tempDir)

	if err := os.MkdirAll(tempDir, 0755); err != nil {
		s.CloneError = "no pudo crear temp dir: " + err.Error()
		s.InstallLog = append(s.InstallLog, "ERROR: "+s.CloneError)
		s.Screen = ScreenInstallDone
		return
	}

	// Check if already cloned
	repoPath := filepath.Join(tempDir, repoName)
	if _, err := os.Stat(repoPath); err == nil {
		s.InstallLog = append(s.InstallLog, "[40%] Repo encontrado en temp, actualizando...")
		s.doGitPullMulti(repoPath)
	} else {
		s.InstallLog = append(s.InstallLog, "[40%] Clonando repositorio...")
		if err := s.doGitCloneMulti(repoURL, repoPath); err != nil {
			s.CloneError = err.Error()
			s.InstallLog = append(s.InstallLog, "ERROR: "+s.CloneError)
			s.Screen = ScreenInstallDone
			return
		}
	}

	// Copy to each SELECTED platform only
	s.InstallLog = append(s.InstallLog, "[70%] Verificando cambios...")
	installedCount := 0
	skippedCount := 0
	remoteVersion := s.checkRemoteVersion(repoPath)
	s.RemoteVersion = remoteVersion
	
	for _, p := range s.PlatformTree {
		if !p.Active || !s.SelectedPlatforms[p.Name] {
			continue
		}
		destPath := filepath.Join(p.BaseDir, p.SkillDir)
		
		// Check if there are changes (skip if not force install)
		shouldInstall := s.ForceInstall
		if !s.ForceInstall {
			hasChanges, err := s.hasChanges(destPath, repoPath)
			if err != nil {
				shouldInstall = true // Force on error
			} else {
				shouldInstall = hasChanges
			}
		}
		
		if !shouldInstall {
			s.InstallLog = append(s.InstallLog, "     [-] "+p.Name+": sin cambios ("+p.Version+")")
			skippedCount++
			continue
		}
		
		// Install (or force install)
		if err := s.copyDir(repoPath, destPath); err != nil {
			s.InstallLog = append(s.InstallLog, "     [!] "+p.Name+": error - "+err.Error())
		} else {
			if s.ForceInstall {
				s.InstallLog = append(s.InstallLog, "     [OK] "+p.Name+": force install ("+p.Version+")")
			} else {
				s.InstallLog = append(s.InstallLog, "     [OK] "+p.Name+": "+p.Version+" -> "+remoteVersion)
			}
			installedCount++
		}
	}

	s.InstallLog = append(s.InstallLog, "")
	s.InstallLog = append(s.InstallLog, "================================")
	if installedCount == selectedCount {
		s.InstallLog = append(s.InstallLog, " INSTALACION COMPLETA")
	} else {
		s.InstallLog = append(s.InstallLog, " INSTALACION PARCIAL")
	}
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, "Plataformas actualizadas: "+fmt.Sprintf("%d/%d", installedCount, selectedCount))
	s.InstallLog = append(s.InstallLog, "")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, " COMO USAR LOS AGENTES:")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, "")
	s.InstallLog = append(s.InstallLog, " OpenCode: sdd c4 plan")
	s.InstallLog = append(s.InstallLog, " Claude:   @elcuatro/desarrollo/dev-c4")
	s.InstallLog = append(s.InstallLog, " Cursor:   usa los comandos del agente")
	s.InstallLog = append(s.InstallLog, "")
	s.CloneDone = true
	s.ForceInstall = false // Reset force flag
	s.Screen = ScreenInstallDone
}

type platformInfo struct {
	Name     string
	SkillDir string
	BaseDir  string
	Active   bool
	Version  string // Version actual instalada
	HasUpdate bool // Hay actualizacion disponible
}

func (s *State) detectAndBuildTree() []platformInfo {
	home, _ := os.UserHomeDir()
	var result []platformInfo
	for _, p := range platforms {
		// Check parent directory to see if platform is installed
		parentPath := filepath.Join(home, p.CheckParent)
		platformExists := false
		if _, err := os.Stat(parentPath); err == nil {
			platformExists = true
		}
		
		// Full path where skills would be
		fullPath := filepath.Join(home, p.SkillDir)
		
		active := false
		version := "(no instalada)"
		
		// Check if C4 skills are installed - SIEMPRE marcar como activa si la plataforma existe
		if platformExists {
			hasContent := false
			possibleFolders := []string{"equipo", "guilds", "reglas", "agents", "sdd-c4"}
			for _, folder := range possibleFolders {
				if _, err := os.Stat(filepath.Join(fullPath, folder)); err == nil {
					hasContent = true
					break
				}
			}
			if hasContent {
				active = true
				version = s.getInstalledVersion(fullPath)
			} else {
				// Plataforma existe pero sin skills - mostrar como disponible para instalar
				active = true  // Enables installation
				version = "(lista para instalar)"
			}
		}
		result = append(result, platformInfo{
			Name:     p.Name,
			SkillDir: p.SkillDir,
			BaseDir:  home,
			Active:   active,
			Version:  version,
		})
	}
	return result
}

func (s *State) checkRemoteVersion(repoPath string) string {
	// Get version from remote repo
	gitDir := filepath.Join(repoPath, ".git")
	if _, err := os.Stat(gitDir); err != nil {
		return "(sin git)"
	}
	
	cmd := exec.Command("git", "-C", repoPath, "describe", "--always", "--dirty")
	if out, err := cmd.Output(); err == nil {
		return strings.TrimSpace(string(out))
	}
	
	return "(desconocido)"
}

func (s *State) hasChanges(localPath, remotePath string) (bool, error) {
	if _, err := os.Stat(localPath); err != nil {
		// No existe local, hay cambios
		return true, nil
	}
	
	// Get local commit
	localCmd := exec.Command("git", "-C", localPath, "rev-parse", "HEAD")
	localOut, localErr := localCmd.Output()
	localCommit := strings.TrimSpace(string(localOut))
	
	// Get remote commit
	remoteCmd := exec.Command("git", "-C", remotePath, "rev-parse", "HEAD")
	remoteOut, remoteErr := remoteCmd.Output()
	remoteCommit := strings.TrimSpace(string(remoteOut))
	
	if localErr != nil || remoteErr != nil {
		return true, nil // Si hay error, actualiza
	}
	
	return localCommit != remoteCommit, nil
}

func (s *State) getInstalledVersion(path string) string {
	// Try to read version from .version file or git describe
	versionFile := filepath.Join(path, "VERSION")
	if data, err := os.ReadFile(versionFile); err == nil {
		return strings.TrimSpace(string(data))
	}

	// Try git describe
	gitDir := filepath.Join(path, ".git")
	if _, err := os.Stat(gitDir); err == nil {
		cmd := exec.Command("git", "-C", path, "describe", "--always", "--dirty")
		if out, err := cmd.Output(); err == nil {
			return strings.TrimSpace(string(out))
		}
	}

	// Check README for version
	readmeFiles := []string{"README.md", "README", "version.txt"}
	for _, rf := range readmeFiles {
		readmePath := filepath.Join(path, rf)
		if data, err := os.ReadFile(readmePath); err == nil {
			lines := strings.Split(string(data), "\n")
			for _, line := range lines {
				if strings.Contains(strings.ToLower(line), "version") {
					if matches := regexp.MustCompile(`(\d+\.\d+\.\d+|[a-f0-9]{7,})`).FindStringSubmatch(line); len(matches) > 1 {
						return matches[1]
					}
				}
			}
		}
	}

return "(desconocido)"
}

func (s *State) getTempDir() string {
	if runtime.GOOS == "windows" {
		return os.Getenv("TEMP")
	}
	return "/tmp"
}

func (s *State) doGitCloneMulti(gitURL, destPath string) error {
	s.InstallLog = append(s.InstallLog, "[50%] Ejecutando git clone...")

	cmd := exec.Command("git", "clone", "--depth=1", gitURL, destPath)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("git clone failed: %s", string(output))
	}
	s.InstallLog = append(s.InstallLog, "[60%] Descargando archivos...")
	return nil
}

func (s *State) doGitPullMulti(repoPath string) {
	s.InstallLog = append(s.InstallLog, "[50%] Ejecutando git pull...")

	cmd := exec.Command("git", "-C", repoPath, "pull", "origin", "master")
	output, err := cmd.CombinedOutput()
	if err != nil {
		s.InstallLog = append(s.InstallLog, "     git pull warning: "+string(output))
	}
}

func (s *State) copyDir(src, dst string) error {
	// Remove existing destination
	os.RemoveAll(dst)
	if err := os.MkdirAll(dst, 0755); err != nil {
		return err
	}

	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		relPath, _ := filepath.Rel(src, path)
		destPath := filepath.Join(dst, relPath)

		if info.IsDir() {
			return os.MkdirAll(destPath, info.Mode())
		}
		return copyFile(path, destPath)
	})
}

func (s *State) getChangelog(localPath, remotePath string) string {
	// Get commits between local and remote
	cmd := exec.Command("git", "-C", remotePath, "log", 
		localPath+".."+remotePath, 
		"--oneline", 
		"-20",
		"--pretty=format:%h %s")
	
	out, err := cmd.Output()
	if err != nil {
		return "No se pudo obtener changelog"
	}
	
	lines := strings.Split(strings.TrimSpace(string(out)), "\n")
	if len(lines) == 0 || (len(lines) == 1 && lines[0] == "") {
		return "Sin cambios"
	}
	
	// Filter empty lines
	var validLines []string
	for _, line := range lines {
		if strings.TrimSpace(line) != "" {
			validLines = append(validLines, line)
		}
	}
	
	if len(validLines) == 0 {
		return "Sin cambios"
	}
	
	// Limit to 15 lines for display
	if len(validLines) > 15 {
		validLines = validLines[:15]
	}
	
	return strings.Join(validLines, "\n")
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()
	_, err = io.Copy(out, in)
	return out.Close()
}

func (s *State) showChangelog() {
	// Count selected platforms
	selectedCount := 0
	for _, p := range s.PlatformTree {
		if p.Active && s.SelectedPlatforms[p.Name] {
			selectedCount++
		}
	}

	if selectedCount == 0 {
		s.Changelog = "No hay plataformas seleccionadas"
		s.PlatformToInstall = "Ninguna"
		s.Screen = ScreenChangelog
		return
	}

	// Build changelog for all selected platforms
	var logLines []string
	tempDir := s.getTempDir()
	repoPath := filepath.Join(tempDir, "elcuatro-agentes")

	for _, p := range s.PlatformTree {
		if !p.Active || !s.SelectedPlatforms[p.Name] {
			continue
		}
		destPath := filepath.Join(p.BaseDir, p.SkillDir)
		
		logLines = append(logLines, "=== "+p.Name+" ("+p.Version+" -> nueva) ===")
		
		// Get changelog between local and remote
		changelog := s.getChangelog(destPath, repoPath)
		if changelog == "Sin cambios" || changelog == "No se pudo obtener changelog" {
			logLines = append(logLines, "  (sin cambios)")
		} else {
			lines := strings.Split(changelog, "\n")
			for _, line := range lines {
				logLines = append(logLines, "  "+line)
			}
		}
		logLines = append(logLines, "")
	}

	s.Changelog = strings.Join(logLines, "\n")
	s.PlatformToInstall = fmt.Sprintf("%d plataforma(s)", selectedCount)
	s.Screen = ScreenChangelog
}

// View implements tea.Model
func (m Model) View() string {
	s := m.State

	switch s.Screen {
	case ScreenMainMenu:
		return s.viewMainMenu()
	case ScreenInstallMenu:
		return s.viewInstallMenu()
	case ScreenInstallSelect:
		return s.viewInstallSelect()
	case ScreenChangelog:
		return s.viewChangelog()
	case ScreenInstallURL, ScreenInstallProgress:
		return s.viewInstall()
	case ScreenInstallDone:
		return s.viewInstallDone()
	case ScreenUninstallMenu:
		return s.viewUninstallMenu()
	case ScreenUninstallProgress:
		return s.viewUninstallProgress()
	case ScreenAgentTree, ScreenAgentView:
		return s.viewAgentTree()
	default:
		return titleStyle.Render("SDD-TUI") + "\n\n" + dimStyle.Render("Unknown screen")
	}
}

func (s *State) viewMainMenu() string {
	const arrow = ">"
	output := titleStyle.Render("SDD-TUI - Agentes C4") + "\n\n"
	output += dimStyle.Render("Gestor de agentes para IA coding") + "\n\n"
	output += dimStyle.Render("Seleccione una opcion:") + "\n\n"

	items := []string{
		"1. Instalar / Actualizar (desde Azure DevOps)",
		"2. Ver Agentes (explorar archivos)",
		"3. Desinstalar (borrar agentes)",
	}

	for i, item := range items {
		if i == s.MenuSelected {
			output += selectedStyle.Render(arrow+" "+item) + "\n"
		} else {
			output += itemStyle.Render("  "+item) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("↑↓ navigate | Enter select | Esc back | q quit")
	return output
}

func (s *State) viewInstallMenu() string {
	const arrow = ">"
	output := titleStyle.Render("Instalar / Actualizar Agentes") + "\n\n"

	output += dimStyle.Render("Fuente: Azure DevOps (elcuatro-agentes)") + "\n"

	// Contar activas
	activeCount := 0
	for _, p := range s.PlatformTree {
		if p.Active {
			activeCount++
		}
	}

	output += dimStyle.Render("Plataformas detectadas: "+fmt.Sprintf("%d", activeCount)) + "\n\n"

	options := []string{
		"1. Instalar todas (verifica cambios)",
		"2. Seleccionar plataformas...",
		"3. URL custom (otro repositorio)",
		"4. Force install (sobrescribir todo)",
	}

	for i, opt := range options {
		if i == s.InstallMode {
			output += selectedStyle.Render(arrow+" "+opt) + "\n"
		} else {
			output += itemStyle.Render("  "+opt) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("Presione Enter para continuar")
	output += "\n" + dimStyle.Render("Presione Escape para volver")

	return output
}

func (s *State) viewInstallSelect() string {
	const arrow = ">"
	output := titleStyle.Render("Seleccionar Plataformas") + "\n\n"

	output += dimStyle.Render("Use Espacio para selecionar/deseleccionar") + "\n"
	output += dimStyle.Render("c para confirmar e instalar") + "\n\n"

	for i, p := range s.PlatformTree {
		prefix := "  "
		checkbox := "[ ]"
		if s.SelectedPlatforms[p.Name] {
			checkbox = "[X]"
		}

		if !p.Active {
			checkbox = "[ ]"
		}

		if i == s.PlatformCursor {
			output += selectedStyle.Render(arrow+prefix+checkbox+" "+p.Name) + "\n"
		} else {
			output += itemStyle.Render(" "+prefix+checkbox+" "+p.Name) + "\n"
		}

		if p.Active {
			output += dimStyle.Render("       "+p.BaseDir+"/"+p.SkillDir) + "\n"
		} else {
			output += dimStyle.Render("       (no detectado)") + "\n"
		}
	}

	output += "\n" + dimStyle.Render("↑↓ navegar | Espacio toggle | c confirmar | Escape volver")

	return output
}

func (s *State) viewChangelog() string {
	output := titleStyle.Render("Changelog") + "\n\n"
	output += dimStyle.Render(s.PlatformToInstall+": "+s.CurrentVersion+" -> "+s.RemoteVersion) + "\n\n"
	
	lines := strings.Split(s.Changelog, "\n")
	for _, line := range lines {
		output += dimStyle.Render("  "+line) + "\n"
	}
	
	output += "\n" + dimStyle.Render("Enter para instalar | Escape para volver")
	return output
}

func (s *State) viewUninstallMenu() string {
	const arrow = ">"
	output := titleStyle.Render("Desinstalar Agentes") + "\n\n"

	output += dimStyle.Render("Seleccione las plataformas a desinstalar") + "\n"
	output += dimStyle.Render("c para confirmar") + "\n\n"

	for i, p := range s.PlatformTree {
		prefix := "  "
		checkbox := "[ ]"
		if s.SelectedPlatforms[p.Name] {
			checkbox = "[X]"
		}

		if !p.Active {
			checkbox = "[ ]"
		}

		if i == s.PlatformCursor {
			output += selectedStyle.Render(arrow+prefix+checkbox+" "+p.Name) + "\n"
		} else {
			output += itemStyle.Render(" "+prefix+checkbox+" "+p.Name) + "\n"
		}

		if p.Active {
			output += dimStyle.Render("       "+p.BaseDir+"/"+p.SkillDir) + "\n"
		} else {
			output += dimStyle.Render("       (no instalado)")
		}
	}

	output += "\n" + dimStyle.Render("↑↓ navegar | Espacio toggle | c confirmar | Escape volver")

	return output
}

func (s *State) viewUninstallProgress() string {
	output := titleStyle.Render("Desinstalando") + "\n\n"

	for _, log := range s.InstallLog {
		if strings.Contains(log, "Error") {
			output += errorStyle.Render("  "+log) + "\n"
		} else if strings.Contains(log, "eliminado") {
			output += successStyle.Render("  "+log) + "\n"
		} else {
			output += dimStyle.Render("  "+log) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("Presione Escape para volver")
	return output
}

func (s *State) doUninstall() {
	s.InstallLog = []string{}
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, " DESINSTALANDO AGENTES")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, "")

	removedCount := 0
	for _, p := range s.PlatformTree {
		if !p.Active || !s.SelectedPlatforms[p.Name] {
			continue
		}
		destPath := filepath.Join(p.BaseDir, p.SkillDir)
		
		if err := os.RemoveAll(destPath); err != nil {
			s.InstallLog = append(s.InstallLog, "     [!] "+p.Name+": error - "+err.Error())
		} else {
			s.InstallLog = append(s.InstallLog, "     [OK] "+p.Name+": eliminado")
			removedCount++
		}
	}

	s.InstallLog = append(s.InstallLog, "")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, " DESINSTALACION COMPLETA")
	s.InstallLog = append(s.InstallLog, "================================")
	s.InstallLog = append(s.InstallLog, fmt.Sprintf("Plataformas limpiadas: %d", removedCount))
	s.InstallLog = append(s.InstallLog, "")

	s.Screen = ScreenUninstallProgress
}

func (s *State) viewInstall() string {
	const arrow = ">"
	output := titleStyle.Render("Instalar/Actualizar") + "\n\n"

	if s.Screen == ScreenInstallProgress {
		output += dimStyle.Render(" procesando...\n\n")
		for _, log := range s.InstallLog {
			output += dimStyle.Render("  "+log) + "\n"
		}
		output += "\n" + dimStyle.Render("Presione Escape para volver")
		return output
	}

	// Si eligió opción 2 (custom), mostrar input
	if s.InstallChoice == 2 {
		output += dimStyle.Render("Ingrese URL del repositorio:") + "\n\n"
		output += "  "

		displayText := s.InputText
		if s.CursorPos == len(s.InputText) {
			displayText += "_"
		}

		if len(displayText) == 1 {
			output += dimStyle.Render("(escriba la URL)")
		} else {
			output += inputStyle.Render(displayText[:s.CursorPos])
			if s.CursorPos < len(displayText) {
				output += displayText[s.CursorPos:]
			}
		}

		output += "\n\n"
		output += dimStyle.Render("Presione Enter para clonar") + "\n"
		output += dimStyle.Render("Presione Escape para volver")
		return output
	}

	// Mostrar menu de opciones
	output += dimStyle.Render("Seleccione una opcion:") + "\n\n"

	options := []string{
		"1. Instalar elcuatro-agentes (default)",
		"2. Instalar otro repositorio",
	}

	for i, opt := range options {
		if i == s.InstallChoice {
			output += selectedStyle.Render(arrow+" "+opt) + "\n"
		} else {
			output += itemStyle.Render("  "+opt) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("Default URL:") + "\n"
	output += dimStyle.Render("  https://dev.azure.com/elcuatro/Proyectos%20IT/_git/elcuatro-agentes") + "\n"
	output += "\n" + dimStyle.Render("↑↓ select | Enter confirmar | Escape volver")
	return output
}

func (s *State) viewInstallDone() string {
	output := titleStyle.Render("Resultado") + "\n\n"

	for _, log := range s.InstallLog {
		if strings.Contains(log, "Error") {
			output += errorStyle.Render("  "+log) + "\n"
		} else if strings.Contains(log, "exitoso") {
			output += successStyle.Render("  "+log) + "\n"
		} else {
			output += dimStyle.Render("  "+log) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("Presione Enter para volver al menu")
	return output
}

func (s *State) viewAgentTree() string {
	output := titleStyle.Render("Ver Agentes") + "\n\n"

	// Si estamos en modo vista de agente, mostrar contenido
	if s.Screen == ScreenAgentView && s.SelectedAgent != "" {
		output += titleStyle.Render("Archivo: "+s.SelectedAgent) + "\n\n"

		// Leer el archivo con path absoluto
		fullPath := "D:/workspace/elcuatro/projects/elcuatro-agentes/" + s.SelectedAgent

		// Ver si es directorio
		info, err := os.Stat(fullPath)
		if err != nil {
			output += errorStyle.Render("Error: "+err.Error()) + "\n"
			output += dimStyle.Render("Path: "+fullPath) + "\n"
		} else if info.IsDir() {
			output += dimStyle.Render("(Es una carpeta, no un archivo)") + "\n"
		} else {
			content, err := os.ReadFile(fullPath)
			if err != nil {
				output += errorStyle.Render("Error al leer: "+err.Error()) + "\n"
				output += dimStyle.Render("Path: "+fullPath) + "\n"
			} else {
// Mostrar primeras líneas
			lines := strings.Split(string(content), "\n")
			for i, line := range lines {
				if i > s.MaxLines { // Usar MaxLines del estado
					output += dimStyle.Render("\n... (presione 'm' para mas)")
					break
				}
					if len(line) > 80 {
						line = line[:80] + "..."
					}
					output += dimStyle.Render(line) + "\n"
				}
			}
		}

		output += "\n" + dimStyle.Render("Presione Escape para volver")
		return output
	}

	// Mostrar árbol de agentes
	const arrow = ">"
	for i, item := range s.Agents {
		prefix := ""
		for j := 0; j < item.Indent; j++ {
			prefix += "  "
		}
		if i == s.AgentCursor {
			output += selectedStyle.Render(arrow+prefix+item.Name) + "\n"
		} else {
			output += itemStyle.Render(" "+prefix+item.Name) + "\n"
		}
	}

	output += "\n" + dimStyle.Render("Presione Enter para seleccionar, Escape para volver")
	return output
}