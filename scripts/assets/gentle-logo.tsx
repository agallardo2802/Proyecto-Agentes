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

const compactArt = ["▣ GGSoluciones AI"]

const Logo = (props: { theme: TuiThemeCurrent }) => {
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
