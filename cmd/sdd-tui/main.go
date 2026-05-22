package main

import (
	"fmt"
	"os"

	"github.com/agallardo2802/Proyecto-Agentes/cmd/sdd-tui/internal/tui"
	"github.com/charmbracelet/bubbletea"
)

func main() {
	m := tui.New()
	p := tea.NewProgram(m)

	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
