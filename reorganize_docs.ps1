# ========================================
# Script de Reorganizacao de Documentacao
# Cria estrutura hierarquica numerada
# ========================================

Write-Host "Reorganizando documentacao do portfolio..." -ForegroundColor Cyan
Write-Host ""

$repoRoot = "C:\Users\admin\GITHUB_ROMER\Repo_Romecy"

# Mapeamento: arquivo_atual -> novo_nome
$renameMap = @{
    # Documentacao Principal (Raiz)
    "README.md" = "1.0-README.md"
    "COMECE_AQUI_TESTES.md" = "1.1-comece-aqui.md"
    "EXPLICACAO_PROJETOS.md" = "1.2-explicacao-projetos.md"

    # Guias e Instrucoes
    "GUIA_DE_TESTES.md" = "2.0-guia-de-testes.md"
    "INSTRUCOES_GIT.md" = "2.1-instrucoes-git.md"
    "README_TESTES.md" = "2.2-readme-testes.md"
}

# Renomear arquivos na raiz
Write-Host "Renomeando arquivos na raiz do repositorio..." -ForegroundColor Yellow
Write-Host ""

foreach ($oldName in $renameMap.Keys) {
    $oldPath = Join-Path $repoRoot $oldName
    $newName = $renameMap[$oldName]
    $newPath = Join-Path $repoRoot $newName

    if (Test-Path $oldPath) {
        if (Test-Path $newPath) {
            Remove-Item $newPath -Force
        }
        Move-Item -Path $oldPath -Destination $newPath -Force
        Write-Host "  [OK] $oldName -> $newName" -ForegroundColor Green
    } else {
        Write-Host "  [SKIP] $oldName nao encontrado" -ForegroundColor Gray
    }
}

# Renomear READMEs dos projetos
Write-Host ""
Write-Host "Renomeando READMEs dos projetos..." -ForegroundColor Yellow
Write-Host ""

$projectMap = @{
    "ansible-infra-baseline" = "3.1"
    "docker-k8s-microservice" = "3.2"
    "itsm-metrics-exporter" = "3.3"
    "rag-helpdesk-assistant" = "3.4"
    "zabbix-grafana-starter" = "3.5"
}

foreach ($project in $projectMap.Keys) {
    $projectPath = Join-Path $repoRoot $project
    $oldReadme = Join-Path $projectPath "README.md"
    $number = $projectMap[$project]
    $newReadme = Join-Path $projectPath "$number-README.md"

    if (Test-Path $oldReadme) {
        if (Test-Path $newReadme) {
            Remove-Item $newReadme -Force
        }
        Move-Item -Path $oldReadme -Destination $newReadme -Force
        Write-Host "  [OK] $project/README.md -> $number-README.md" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Reorganizacao concluida!" -ForegroundColor Green
Write-Host ""
Write-Host "Estrutura criada:" -ForegroundColor Cyan
Write-Host "  1.0 - README Principal" -ForegroundColor White
Write-Host "  1.1 - Comece Aqui" -ForegroundColor White
Write-Host "  1.2 - Explicacao dos Projetos" -ForegroundColor White
Write-Host "  2.0 - Guia de Testes" -ForegroundColor White
Write-Host "  2.1 - Instrucoes Git" -ForegroundColor White
Write-Host "  2.2 - README Testes" -ForegroundColor White
Write-Host "  3.1 - Ansible Infra Baseline" -ForegroundColor White
Write-Host "  3.2 - Docker & K8s Microservice" -ForegroundColor White
Write-Host "  3.3 - ITSM Metrics Exporter" -ForegroundColor White
Write-Host "  3.4 - RAG Helpdesk Assistant" -ForegroundColor White
Write-Host "  3.5 - Zabbix Grafana Starter" -ForegroundColor White
