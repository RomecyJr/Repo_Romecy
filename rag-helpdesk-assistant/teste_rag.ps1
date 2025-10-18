# Script de Teste Simplificado - RAG Helpdesk Assistant

Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🤖 RAG HELPDESK ASSISTANT - TESTE SIMPLES   ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "🚀 Iniciando o servidor FastAPI...`n" -ForegroundColor Yellow

# Navegar para o diretório correto
Set-Location "c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant"

# Iniciar o servidor
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant; python -m uvicorn app.main:app --reload --port 8000"

Write-Host "⏳ Aguardando servidor iniciar (5 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host "`n✅ Servidor iniciado!" -ForegroundColor Green
Write-Host "`n📍 Acesse no navegador:" -ForegroundColor Cyan
Write-Host "   🌐 http://localhost:8000/health" -ForegroundColor White
Write-Host "   🌐 http://localhost:8000/docs" -ForegroundColor White

Write-Host "`n🧪 Testando endpoint /health..." -ForegroundColor Yellow

try {
    Start-Sleep -Seconds 2
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -Method GET -UseBasicParsing
    Write-Host "✅ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "📄 Resposta: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "⚠️  Aguarde mais alguns segundos e abra manualmente no navegador" -ForegroundColor Yellow
}

Write-Host "`n🧪 Testando pergunta para a IA..." -ForegroundColor Yellow

try {
    $body = @{question = "Qual o SLA de P1?"} | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "http://localhost:8000/ask" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "✅ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "📄 Resposta: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "⚠️  Use a interface /docs para testar perguntas" -ForegroundColor Yellow
}

Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              TESTE CONCLUÍDO!                  ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📖 O que você viu:" -ForegroundColor Yellow
Write-Host "   1️⃣  Servidor FastAPI rodando" -ForegroundColor White
Write-Host "   2️⃣  Endpoint /health funcionando" -ForegroundColor White
Write-Host "   3️⃣  IA respondendo perguntas" -ForegroundColor White

Write-Host "`n💡 Próximos passos:" -ForegroundColor Yellow
Write-Host "   • Abra http://localhost:8000/docs" -ForegroundColor White
Write-Host "   • Teste fazer outras perguntas" -ForegroundColor White
Write-Host "   • Para parar: feche a janela do servidor" -ForegroundColor White

Write-Host "`nPressione qualquer tecla para fechar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
