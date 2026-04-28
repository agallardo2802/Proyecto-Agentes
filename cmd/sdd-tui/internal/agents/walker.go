package agents

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
)

type AgentNode struct {
	Name     string
	Path    string
	IsDir   bool
	Parent  *AgentNode
	Children []*AgentNode
}

type Walker struct {
	RootDir string
}

var directories = []string{"agents", "guilds", "reglas", "templates"}

func NewWalker(rootDir string) *Walker {
	return &Walker{RootDir: rootDir}
}

func (w *Walker) Walk() (*AgentNode, error) {
	if w.RootDir == "" {
		w.RootDir = "."
	}

	root := &AgentNode{
		Name:   "root",
		Path:  w.RootDir,
		IsDir:  true,
	}

	for _, dir := range directories {
		dirPath := filepath.Join(w.RootDir, dir)
		if _, err := os.Stat(dirPath); err == nil {
			child := &AgentNode{
				Name:   dir,
				Path:  dirPath,
				IsDir: true,
				Parent: root,
			}
			w.walkDir(child, dirPath)
			root.Children = append(root.Children, child)
		}
	}

	return root, nil
}

func (w *Walker) walkDir(node *AgentNode, path string) error {
	entries, err := os.ReadDir(path)
	if err != nil {
		return err
	}

	for _, entry := range entries {
		if entry.IsDir() {
			child := &AgentNode{
				Name:   entry.Name(),
				Path:  filepath.Join(path, entry.Name()),
				IsDir:  true,
				Parent: node,
			}
			w.walkDir(child, filepath.Join(path, entry.Name()))
			node.Children = append(node.Children, child)
		} else if strings.HasSuffix(entry.Name(), ".md") {
			node.Children = append(node.Children, &AgentNode{
				Name:   entry.Name(),
				Path:  filepath.Join(path, entry.Name()),
				IsDir:  false,
				Parent: node,
			})
		}
	}

	return nil
}

func (w *Walker) ReadAgent(path string) (string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

var ErrAgentNotFound = errors.New("agent not found")

func (w *Walker) GetDirectories() ([]string, error) {
	var dirs []string
	for _, dir := range directories {
		dirPath := filepath.Join(w.RootDir, dir)
		if _, err := os.Stat(dirPath); err == nil {
			dirs = append(dirs, dir)
		}
	}
	return dirs, nil
}