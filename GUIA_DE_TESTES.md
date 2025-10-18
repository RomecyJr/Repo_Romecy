# 🧪 Guia Completo de Testes - Portfólio Romecy

Este guia te mostra **como testar cada projeto** do seu portfólio passo a passo.

---

## 📋 Pré-requisitos Gerais

Antes de testar os projetos, você precisa ter instalado:

### 1. **Python 3.11+**
```powershell
# Verificar se está instalado:
python --version

# Se não tiver, baixe em: https://www.python.org/downloads/
```

### 2. **Docker Desktop** (opcional, mas recomendado)
```powershell
# Verificar se está instalado:
docker --version

# Baixe em: https://www.docker.com/products/docker-desktop/
```

### 3. **Node.js** (para alguns testes)
```powershell
# Verificar:
node --version

# Baixe em: https://nodejs.org/
```

---

## 🤖 1. RAG Helpdesk Assistant

### O que é?
Assistente inteligente que responde perguntas sobre suporte técnico usando IA.

### Teste Local (Sem Docker)

```powershell
# 1. Navegue até a pasta do projeto
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant

# 2. Crie um ambiente virtual Python
python -m venv .venv

# 3. Ative o ambiente virtual
.\.venv\Scripts\Activate.ps1

# 4. Instale as dependências
pip install -r requirements.txt

# 5. Inicie o servidor
uvicorn app.main:app --reload

# 6. Aguarde a mensagem: "Uvicorn running on http://127.0.0.1:8000"
```

### Testando as APIs:

#### **Opção 1 - Pelo navegador:**
Abra: http://localhost:8000/health

Você deve ver: `{"status":"ok"}`

Abra: http://localhost:8000/docs

Você verá a documentação interativa da API!

#### **Opção 2 - Pelo PowerShell:**
```powershell
# Teste o endpoint de saúde
curl http://localhost:8000/health

# Teste uma pergunta ao assistente
curl -X POST http://localhost:8000/ask `
  -H "Content-Type: application/json" `
  -d '{\"question\":\"Qual o SLA de P1?\"}'
```

### Teste com Docker:

```powershell
# 1. Construa a imagem
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant
docker build -t rag-helpdesk:local .

# 2. Execute o container
docker run -p 8000:8000 rag-helpdesk:local

# 3. Teste no navegador
# Acesse: http://localhost:8000/health
```

### Para parar:
- Pressione `Ctrl+C` no terminal

---

## 📊 2. ITSM Metrics Exporter

### O que é?
Exporta métricas simuladas de sistemas ITSM (Jira, Tiflux, OTRS) para monitoramento.

### Teste Local:

```powershell
# 1. Navegue até a pasta
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\itsm-metrics-exporter

# 2. Crie ambiente virtual
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# 3. Instale dependências
pip install -r requirements.txt

# 4. Execute o exportador
python exporter.py

# Você verá: Servidor iniciado na porta 9108
```

### Testando as Métricas:

```powershell
# Abra outro terminal PowerShell e execute:
curl http://localhost:9108/metrics
```

Você verá métricas como:
```
itsm_open_tickets{source="jira",priority="P1"} 3.0
itsm_mttr_hours{source="jira"} 4.5
itsm_tma_minutes{source="tiflux"} 15.2
```

### Visualizando no Grafana (avançado):
1. Instale Grafana: https://grafana.com/grafana/download
2. Configure Prometheus para coletar as métricas
3. Importe o dashboard: `grafana/dashboard.json`

---

## ⚙️ 3. Ansible Infra Baseline

### O que é?
Automação de configuração e hardening de servidores Linux/Windows.

### Pré-requisitos Adicionais:

```powershell
# Instalar Ansible (via Python)
pip install ansible

# Verificar instalação
ansible --version
```

### Teste de Sintaxe (sem executar em servidores):

```powershell
# Navegue até a pasta
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\ansible-infra-baseline

# Verifique a sintaxe dos playbooks
ansible-playbook --syntax-check playbooks/linux_hardening.yml
ansible-playbook --syntax-check playbooks/windows_updates.yml

# Se não houver erros, você verá: "playbook: playbooks/linux_hardening.yml"
```

### Teste Dry-Run (simulação):

```powershell
# Simula a execução sem fazer mudanças
ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml --check
```

### ⚠️ Teste Real (requer servidores):
```powershell
# ATENÇÃO: Só execute se tiver servidores configurados!
# Ajuste os IPs em: inventories/dev/hosts.ini

ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml
```

---

## 📈 4. Zabbix + Grafana Starter

### O que é?
Script de descoberta de discos para monitoramento Zabbix.

### Teste do Script LLD:

```powershell
# Navegue até a pasta
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\zabbix-grafana-starter

# Execute o script de descoberta
python lld/disks_discovery.py
```

**Saída esperada:**
```json
{"data": [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]}
```

### Integração com Zabbix (avançado):
1. Instale Zabbix Server
2. Crie um Item de Discovery
3. Use o script `lld/disks_discovery.py`
4. Configure protótipos de itens para monitorar uso de disco

---

## 🐳 5. Docker/K8s Microservice

### O que é?
Microserviço Flask simples com Docker e Kubernetes.

### Teste Local (Python):

```powershell
# 1. Navegue até a pasta
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice

# 2. Crie ambiente virtual
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# 3. Instale dependências
pip install -r requirements.txt

# 4. Execute o microserviço
python -m flask --app src.app run

# 5. Aguarde: "Running on http://127.0.0.1:5000"
```

### Testando:

```powershell
# Abra outro terminal e teste:
curl http://localhost:5000/health
# Resposta: {"status":"ok"}

curl http://localhost:5000/
# Resposta: {"message":"hello from microservice"}
```

### Teste com Docker:

```powershell
# 1. Construa a imagem
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice
docker build -t demo-ms:local .

# 2. Execute o container
docker run -p 8080:5000 demo-ms:local

# 3. Teste em outro terminal
curl http://localhost:8080/health
```

### Teste com Docker Compose:

```powershell
# Execute tudo com um comando:
docker-compose up

# Para parar:
docker-compose down
```

### Teste com Kubernetes (requer cluster):

```powershell
# 1. Verifique se kubectl está instalado
kubectl version

# 2. Aplique os manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# 3. Verifique os pods
kubectl get pods

# 4. Verifique o serviço
kubectl get services
```

---

## 🎯 Testes Rápidos - Resumo

### Para testar TUDO rapidamente:

```powershell
# 1. RAG Helpdesk Assistant
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload
# Abra: http://localhost:8000/docs

# 2. ITSM Metrics Exporter (nova janela)
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\itsm-metrics-exporter
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python exporter.py
# Abra: http://localhost:9108/metrics

# 3. Ansible - Verificar sintaxe
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\ansible-infra-baseline
pip install ansible
ansible-playbook --syntax-check playbooks/linux_hardening.yml

# 4. Zabbix - Testar script
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\zabbix-grafana-starter
python lld/disks_discovery.py

# 5. Microservice
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python -m flask --app src.app run
# Abra: http://localhost:5000/health
```

---

## 🐛 Troubleshooting - Problemas Comuns

### Erro: "python: command not found"
**Solução:** Instale Python 3.11+ de https://www.python.org/downloads/

### Erro: "pip: command not found"
**Solução:**
```powershell
python -m ensurepip --upgrade
```

### Erro: "Cannot activate virtual environment"
**Solução:** Execute como Administrador ou ajuste a política:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Erro: "Port already in use"
**Solução:** Pare o processo usando a porta:
```powershell
# Encontre o processo na porta 8000
netstat -ano | findstr :8000

# Mate o processo (substitua PID pelo número encontrado)
taskkill /PID <PID> /F
```

### Erro: "Docker daemon not running"
**Solução:** Inicie o Docker Desktop

### Erro: "Module not found"
**Solução:** Certifique-se de que o ambiente virtual está ativado:
```powershell
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

---

## 📚 Recursos Adicionais

### Documentação dos Projetos:
- **FastAPI:** https://fastapi.tiangolo.com/
- **LangChain:** https://python.langchain.com/
- **Prometheus:** https://prometheus.io/docs/
- **Ansible:** https://docs.ansible.com/
- **Kubernetes:** https://kubernetes.io/docs/

### Tutoriais em Vídeo:
- FastAPI Tutorial: https://www.youtube.com/results?search_query=fastapi+tutorial
- Docker Tutorial: https://www.youtube.com/results?search_query=docker+tutorial+iniciantes

---

## 🎓 Próximos Passos

1. **Teste cada projeto individualmente**
2. **Personalize as funcionalidades**
3. **Adicione mais features**
4. **Documente suas melhorias**
5. **Compartilhe no LinkedIn!**

---

## 💡 Dicas Pro

- Use **VS Code** com extensões Python, Docker, Ansible
- Configure **GitHub Actions** para CI/CD automático
- Adicione **testes automatizados** com pytest
- Crie **badges** no README para mostrar status
- Documente **casos de uso reais**

---

**Boa sorte com os testes! 🚀**

Se tiver dúvidas, consulte os READMEs individuais de cada projeto.
