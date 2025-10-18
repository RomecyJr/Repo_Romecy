#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Write-Host "▶️ Iniciando migração de estrutura..."

$null = New-Item -ItemType Directory -Force -Path "projetos","docs\projetos","scripts\bash","scripts\powershell",".vscode",".github\workflows"

# Função auxiliar git mv -> fallback mv
function Move-GitOrFs($src,$dst){
  if (Test-Path $src) {
    $dstDir = Split-Path $dst -Parent
    if ($dstDir) {
      New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }
    try { git mv -k "$src" "$dst" 2>$null } catch { Move-Item -LiteralPath $src -Destination $dst -Force -ErrorAction SilentlyContinue }
  }
}

# Projetos
$projetos = "rag-helpdesk-assistant","itsm-metrics-exporter","ansible-infra-baseline","zabbix-grafana-starter","docker-k8s-microservice"
foreach ($p in $projetos) {
  if (Test-Path $p) { Move-GitOrFs $p "projetos/$p" }
}

# Docs
$mapa = @{
  "1.0-README.md" = "docs/README.md";
  "0.0-INDICE.md" = "docs/indice.md";
  "1.1-comece-aqui.md" = "docs/comece-aqui.md";
  "1.2-explicacao-projetos.md" = "docs/explicacao-projetos.md";
  "2.0-guia-de-testes.md" = "docs/guia-de-testes.md";
  "2.1-instrucoes-git.md" = "docs/instrucoes-git.md";
  "2.2-readme-testes.md" = "docs/readme-testes.md";
  ".markdownlint.json" = ".markdownlint.jsonc";
  "PROFILE_README" = "docs/profile-readme.md"
}
foreach ($origem in $mapa.Keys) {
  if ($origem) { Move-GitOrFs $origem $mapa[$origem] }
}

# Scripts
foreach ($s in "setup_portfolio.sh","vscode_llm_setup.sh") {
  if (Test-Path $s) { Move-GitOrFs $s "scripts/bash/$s" }
}
foreach ($s in "setup_portfolio_simple.ps1","vscode_llm_setup.ps1","reorganize_docs.ps1") {
  if (Test-Path $s) { Move-GitOrFs $s "scripts/powershell/$s" }
}

# Placeholders docs de projetos
foreach ($p in $projetos) {
  $dest = "docs/projetos/$p.md"
  if (-not (Test-Path $dest)) { "# $p" | Set-Content $dest -Encoding UTF8 }
}

Write-Host "✅ Migração concluída."
