# ========================================
# Script de Teste - Docker/K8s Microservice
# ========================================

Write-Host "`n🐳 TESTANDO DOCKER/K8S MICROSERVICE`n" -ForegroundColor Cyan

# Navegar para o diretório
Set-Location "c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice"

# Iniciar o servidor em background
Write-Host "▶️  Iniciando o servidor Flask..." -ForegroundColor Yellow
$job = Start-Job -ScriptBlock {
    Set-Location "c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice"
    & ".\.venv\Scripts\python.exe" -m flask --app src.app run
}

# Aguardar o servidor iniciar
Write-Host "⏳ Aguardando servidor inicializar..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Testar o endpoint /health
Write-Host "`n✅ Testando endpoint /health..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Resposta: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "❌ Erro ao acessar /health: $_" -ForegroundColor Red
}

# Testar o endpoint /
Write-Host "`n✅ Testando endpoint / (home)..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Resposta: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "❌ Erro ao acessar /: $_" -ForegroundColor Red
}

Write-Host "`n🌐 Servidor está rodando em: http://localhost:5000" -ForegroundColor Cyan
Write-Host "📖 Abra no navegador para testar!" -ForegroundColor Cyan
Write-Host "`nPressione qualquer tecla para parar o servidor..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Parar o servidor
Write-Host "`n⏹️  Parando o servidor..." -ForegroundColor Yellow
Stop-Job -Job $job
Remove-Job -Job $job

Write-Host "✅ Teste concluído!`n" -ForegroundColor Green
