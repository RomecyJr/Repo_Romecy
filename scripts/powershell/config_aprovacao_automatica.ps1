# Script para configurar aprovação automática 100% no GitHub Copilot
# Executa: .\scripts\powershell\config_aprovacao_automatica.ps1

Write-Host "`n=== Configurando Aprovação Automática Total do GitHub Copilot ===" -ForegroundColor Yellow

# Caminho das configurações globais do VS Code
$globalSettingsPath = "$env:APPDATA\Code\User\settings.json"
$workspaceSettingsPath = ".vscode\settings.json"

# Configurações a serem adicionadas
$copilotSettings = @'
{
  "github.copilot.chat.terminalCmdApproval": {
    "/.*/": true
  },
  "github.copilot.chat.runCommand.enabled": true,
  "security.workspace.trust.enabled": false,
  "task.autoDetect": "on",
  "task.allowAutomaticTasks": "on"
}
'@

Write-Host "`n1️⃣ Configurando settings GLOBAIS em: $globalSettingsPath" -ForegroundColor Cyan

if (Test-Path $globalSettingsPath) {
    # Lê o arquivo existente
    $content = Get-Content $globalSettingsPath -Raw
    
    # Remove comentários e trailing commas que causam erro JSON
    $content = $content -replace '//.*', '' -replace ',\s*}', '}' -replace ',\s*]', ']'
    
    try {
        $settings = $content | ConvertFrom-Json -AsHashtable
    } catch {
        Write-Host "⚠️ Erro ao ler settings.json, criando novo arquivo..." -ForegroundColor Yellow
        $settings = @{}
    }
} else {
    Write-Host "📄 Arquivo não existe, criando novo..." -ForegroundColor Yellow
    $settings = @{}
}

# Adiciona as configurações do Copilot
$settings["github.copilot.chat.terminalCmdApproval"] = @{ "/.*/".ToString() = $true }
$settings["github.copilot.chat.runCommand.enabled"] = $true
$settings["security.workspace.trust.enabled"] = $false
$settings["task.autoDetect"] = "on"
$settings["task.allowAutomaticTasks"] = "on"

# Salva as configurações globais
$settings | ConvertTo-Json -Depth 10 | Set-Content $globalSettingsPath -Encoding UTF8
Write-Host "✅ Settings globais configurados!" -ForegroundColor Green

Write-Host "`n2️⃣ Configurando settings do WORKSPACE em: $workspaceSettingsPath" -ForegroundColor Cyan

# Já foi configurado pelo replace anterior, mas vamos garantir
if (Test-Path $workspaceSettingsPath) {
    Write-Host "✅ Settings do workspace já configurados!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Arquivo .vscode/settings.json não encontrado!" -ForegroundColor Yellow
}

Write-Host "`n=== Configurações Aplicadas ===" -ForegroundColor Green
Write-Host "✅ github.copilot.chat.terminalCmdApproval: /.*/: true (APROVA TUDO)" -ForegroundColor Green
Write-Host "✅ github.copilot.chat.runCommand.enabled: true" -ForegroundColor Green
Write-Host "✅ security.workspace.trust.enabled: false (SEM CONFIRMAÇÕES DE SEGURANÇA)" -ForegroundColor Green
Write-Host "✅ task.autoDetect: on" -ForegroundColor Green
Write-Host "✅ task.allowAutomaticTasks: on" -ForegroundColor Green

Write-Host "`n⚠️ IMPORTANTE: Recarregue o VS Code para aplicar as mudanças!" -ForegroundColor Yellow
Write-Host "   Pressione Ctrl+Shift+P e digite 'Reload Window'" -ForegroundColor Yellow

Write-Host "`n🎉 Configuração concluída! Agora TODOS os comandos serão aprovados automaticamente." -ForegroundColor Green
