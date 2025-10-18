#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "🔧 Instalando hooks do pre-commit..."
if (Get-Command pre-commit -ErrorAction SilentlyContinue) {
  pre-commit install
} else {
  Write-Error "Instale 'pre-commit' (pipx install pre-commit ou pip install pre-commit)."
}

Write-Host "✅ Pronto. Consulte README.md para próximos passos."
