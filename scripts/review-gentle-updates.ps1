<#
.SYNOPSIS
Ayuda a revisar novedades de Gentle AI/OpenCode antes de incorporarlas a GGS.

.DESCRIPTION
No aplica cambios automticamente. El objetivo es evitar un fork y promover curacin:
core universal se adopta en Gentle/OpenCode; contexto GGSoluciones se adapta como skill,
template, standard o config GGS.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "GGS Agentes v2 - revision de novedades Gentle" -ForegroundColor Cyan

$Checks = @(
    "El cambio es core universal de Gentle/OpenCode? -> actualizar base",
    "El cambio es una practica reusable para GGSoluciones? -> adaptar como skill GGS",
    "El cambio reemplaza un agente propio? -> simplificar o borrar lo propio",
    "El cambio es especifico de otro contexto? -> ignorar"
)

foreach ($Check in $Checks) {
    Write-Host "- $Check"
}

Write-Host "Este script es deliberadamente read-only en v2 inicial." -ForegroundColor Yellow
