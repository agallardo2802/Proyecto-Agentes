// @ts-nocheck
/** @jsxImportSource @opentui/solid */
import type { TuiPlugin, TuiPluginModule } from "@opencode-ai/plugin/tui"
import { useTerminalDimensions } from "@opentui/solid"
import { createMemo } from "solid-js"

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

const compactArt = ["▣ GGSoluciones AI"]

const Logo = () => {
  const dim = useTerminalDimensions()
  const lines = createMemo(() => {
    const term = dim()
    return term.height >= ggsArt.length + 6 && term.width >= 58 ? ggsArt : compactArt
  })

  return (
    <box flexDirection="column" alignItems="center">
      {lines().map((line) => (
        <text fg="#E30613">{line}</text>
      ))}
    </box>
  )
}

// API actual de OpenCode (spec tui-plugins): register recibe { slots: { <slot>: { render } } }.
// No se permite pasar "id" dentro de register; el id va solo en el export del plugin.
// El slot home_logo usa modo "replace": reemplaza el logo por defecto de OpenCode.
const tui: TuiPlugin = async (api) => {
  api.slots.register({
    slots: {
      home_logo: {
        render: () => <Logo />,
      },
    },
  })
}

const plugin: TuiPluginModule & { id: string } = {
  id: "gentle-logo",
  tui,
}

export default plugin
