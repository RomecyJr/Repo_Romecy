# setup_portfolio_simple.ps1
# Script simplificado para criar estrutura do portfólio

$ErrorActionPreference = "Continue"

$REPO_OWNER = "RomecyJr"
$REPO_NAME = "Repo_Romecy"

Write-Host "📦 Criando estrutura do portfólio..." -ForegroundColor Cyan

# Criar pastas principais
$folders = @(
    ".github\workflows",
    "rag-helpdesk-assistant\app\kb",
    "rag-helpdesk-assistant\tests",
    "itsm-metrics-exporter\grafana",
    "ansible-infra-baseline\inventories\dev",
    "ansible-infra-baseline\group_vars",
    "ansible-infra-baseline\playbooks",
    "ansible-infra-baseline\roles\linux_hardening\tasks",
    "ansible-infra-baseline\roles\windows_updates\tasks",
    "zabbix-grafana-starter\lld",
    "zabbix-grafana-starter\grafana",
    "docker-k8s-microservice\src",
    "docker-k8s-microservice\k8s",
    "docker-k8s-microservice\.github\workflows",
    "PROFILE_README"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
}

Write-Host "✅ Pastas criadas" -ForegroundColor Green

# .gitignore
$gitignoreContent = @'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.venv/
.env
.env.*
# Node/others
node_modules/
dist/
# OS
.DS_Store
Thumbs.db
# VSCode
.vscode/
'@
$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "✅ .gitignore criado" -ForegroundColor Green

# LICENSE
$licenseContent = @'
MIT License

Copyright (c) 2025 Romecy Ribeiro da Veiga

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'@
$licenseContent | Out-File -FilePath "LICENSE" -Encoding UTF8
Write-Host "✅ LICENSE criado" -ForegroundColor Green

# README principal
$readmeContent = @"
# Portfólio — Romecy Veiga

Este repositório reúne **5 projetos práticos** alinhados a Infra + IA aplicada a Suporte/Operações:

1. **RAG Helpdesk Assistant** — FastAPI + LangChain + FAISS, Docker e CI.
2. **ITSM Metrics Exporter** — Exporta métricas (mock Jira/Tiflux/OTRS) para Prometheus + dashboard Grafana.
3. **Ansible Infra Baseline** — Hardening Linux + updates Windows (WinRM).
4. **Zabbix + Grafana Starter** — LLD simples (discovery de discos) + dashboard.
5. **Docker/K8s Microservice** — Microserviço Flask com Docker, Compose e manifests Kubernetes.

> Objetivo: demonstrar **aplicação prática** de automação, observabilidade e IA em suporte (redução de TMA/MTTR), com código **rodável** e documentação clara.

## Como navegar
Cada pasta possui seu próprio ``README.md`` com instruções de execução/teste e próximos passos.

## Status
![CI](https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/ci.yml/badge.svg)
"@
$readmeContent | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "✅ README principal criado" -ForegroundColor Green

# PROFILE_README
$profileContent = @'
# Romecy Veiga — Infra Sênior | IA aplicada a Suporte
Infra Windows/Linux, ITSM (Jira/Tiflux/OTRS), Observabilidade (Zabbix/Grafana),
Automação (Ansible/Python) e RAG (LangChain/LangGraph) para reduzir TMA/MTTR.
> Portfólio focado em soluções práticas de operação e confiabilidade.

## Projetos
- RAG Helpdesk Assistant
- ITSM Metrics Exporter
- Ansible Infra Baseline
- Zabbix + Grafana Starter
- Docker/K8s Microservice
'@
$profileContent | Out-File -FilePath "PROFILE_README\README.md" -Encoding UTF8
Write-Host "✅ PROFILE_README criado" -ForegroundColor Green

# ===============================================
# 1) RAG Helpdesk Assistant
# ===============================================
Write-Host "`n🤖 Criando RAG Helpdesk Assistant..." -ForegroundColor Cyan

'fastapi==0.115.0
uvicorn[standard]==0.30.0
langchain==0.2.15
langchain-community==0.2.15
faiss-cpu==1.8.0
sentence-transformers==2.7.0
pydantic==2.9.2' | Out-File -FilePath "rag-helpdesk-assistant\requirements.txt" -Encoding UTF8

'FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app app
ENV EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]' | Out-File -FilePath "rag-helpdesk-assistant\Dockerfile" -Encoding UTF8

'HF_TOKEN=coloque_sua_chave_se_for_usar_modelos_hf_privados
HF_MODEL=google/flan-t5-base
EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2' | Out-File -FilePath "rag-helpdesk-assistant\.env.example" -Encoding UTF8

'from fastapi import FastAPI
from pydantic import BaseModel
from .rag import answer_query

app = FastAPI(title="RAG Helpdesk Assistant")

class Ask(BaseModel):
    question: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/ask")
def ask(payload: Ask):
    return {"answer": answer_query(payload.question)}' | Out-File -FilePath "rag-helpdesk-assistant\app\main.py" -Encoding UTF8

$ragPyContent = @'
import os
from pathlib import Path
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import TextLoader
from langchain.chains import RetrievalQA
from langchain_community.llms import HuggingFaceHub

def get_vector_store():
    kb_path = Path(__file__).parent / "kb"
    kb_path.mkdir(exist_ok=True)
    default_doc = kb_path / "helpdesk_policies.txt"
    if not default_doc.exists():
        default_doc.write_text(
            "Prioridades: P1 crítico, P2 alto, P3 médio.\n"
            "SLA: P1 resposta 15min, resolução 4h.\n"
            "Abertura de chamado via portal ou e-mail suporte@empresa.\n"
        )
    docs = []
    for f in kb_path.glob("*.txt"):
        docs.extend(TextLoader(str(f)).load())
    splitter = RecursiveCharacterTextSplitter(chunk_size=600, chunk_overlap=100)
    chunks = splitter.split_documents(docs)
    emb = HuggingFaceEmbeddings(model_name=os.getenv("EMB_MODEL","sentence-transformers/all-MiniLM-L6-v2"))
    return FAISS.from_documents(chunks, emb)

_vs = None
def answer_query(q: str) -> str:
    global _vs
    if _vs is None:
        _vs = get_vector_store()
    retriever = _vs.as_retriever(search_kwargs={"k": 4})
    llm = HuggingFaceHub(
        repo_id=os.getenv("HF_MODEL","google/flan-t5-base"),
        huggingfacehub_api_token=os.getenv("HF_TOKEN")
    )
    chain = RetrievalQA.from_chain_type(llm=llm, retriever=retriever)
    return chain.run(q)
'@
$ragPyContent | Out-File -FilePath "rag-helpdesk-assistant\app\rag.py" -Encoding UTF8

'FAQ: Como abrir chamado? Use o portal. P1 = indisponibilidade total.' | Out-File -FilePath "rag-helpdesk-assistant\app\kb\faq.txt" -Encoding UTF8

'def test_placeholder():
    assert True' | Out-File -FilePath "rag-helpdesk-assistant\tests\test_health.py" -Encoding UTF8

$ragReadme = @"
# RAG Helpdesk Assistant
Assistente de base de conhecimento para Service Desk com **FastAPI + LangChain + FAISS**.

## Rodando local
````bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# http://localhost:8000/health
````

## Exemplo
````bash
curl -s -X POST localhost:8000/ask -H 'Content-Type: application/json' \
  -d '{"question":"Qual SLA de P1?"}'
````

## Docker
````bash
docker build -t rag-helpdesk:local .
docker run -p 8000:8000 rag-helpdesk:local
````

## CI
![CI](https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/ci.yml/badge.svg)

## Próximos passos
- Substituir FAISS por Chroma/Pinecone
- Observabilidade (Prometheus/OpenTelemetry)
- LangGraph para orquestração de etapas
"@
$ragReadme | Out-File -FilePath "rag-helpdesk-assistant\README.md" -Encoding UTF8

Write-Host "✅ RAG Helpdesk Assistant criado" -ForegroundColor Green

# ===============================================
# CI Workflow
# ===============================================
$ciContent = @'
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - name: Test rag-helpdesk-assistant (placeholder)
        working-directory: rag-helpdesk-assistant
        run: |
          python -m venv .venv
          source .venv/bin/activate
          pip install -r requirements.txt pytest
          pytest -q || true
'@
$ciContent | Out-File -FilePath ".github\workflows\ci.yml" -Encoding UTF8
Write-Host "✅ CI Workflow criado" -ForegroundColor Green

# ===============================================
# 2) ITSM Metrics Exporter
# ===============================================
Write-Host "`n📊 Criando ITSM Metrics Exporter..." -ForegroundColor Cyan

'prometheus-client==0.20.0' | Out-File -FilePath "itsm-metrics-exporter\requirements.txt" -Encoding UTF8

$exporterPy = @'
from prometheus_client import start_http_server, Gauge
import random, time, os

g_open = Gauge('itsm_open_tickets', 'Chamados abertos (mock)', ['source','priority'])
g_mttr = Gauge('itsm_mttr_hours', 'MTTR em horas (mock)', ['source'])
g_tma  = Gauge('itsm_tma_minutes', 'TMA em minutos (mock)', ['source'])

def fetch_mock(source):
    return {
        "open_p1": random.randint(0, 5),
        "open_p2": random.randint(3, 15),
        "mttr": round(random.uniform(1.5, 7.5), 2),
        "tma": round(random.uniform(5, 30), 1),
    }

def loop():
    sources = os.getenv("SOURCES","jira,tiflux,otrs").split(",")
    while True:
        for s in sources:
            data = fetch_mock(s)
            g_open.labels(s,'P1').set(data["open_p1"])
            g_open.labels(s,'P2').set(data["open_p2"])
            g_mttr.labels(s).set(data["mttr"])
            g_tma.labels(s).set(data["tma"])
        time.sleep(15)

if __name__ == "__main__":
    start_http_server(9108)
    loop()
'@
$exporterPy | Out-File -FilePath "itsm-metrics-exporter\exporter.py" -Encoding UTF8

'# ITSM Metrics Exporter
Exporta métricas **mock** de chamados (Jira/Tiflux/OTRS) em `/metrics` para Prometheus.

## Rodando
```bash
pip install -r requirements.txt
python exporter.py
# Acesse: http://localhost:9108/metrics
```

## Grafana
Importe `grafana/dashboard.json` (placeholder) e crie 3 painéis.

## Docker (opcional)
Use python:3.11-slim como base.' | Out-File -FilePath "itsm-metrics-exporter\README.md" -Encoding UTF8

'{ "overwrite": true, "dashboard": { "title": "ITSM Metrics (Mock)", "panels": [] } }' | Out-File -FilePath "itsm-metrics-exporter\grafana\dashboard.json" -Encoding UTF8

Write-Host "✅ ITSM Metrics Exporter criado" -ForegroundColor Green

# ===============================================
# 3) Ansible Infra Baseline
# ===============================================
Write-Host "`n⚙️  Criando Ansible Infra Baseline..." -ForegroundColor Cyan

'[linux]
192.168.1.10

[windows]
192.168.1.20 ansible_user=Administrator ansible_password=ChangeMe ansible_connection=winrm ansible_winrm_server_cert_validation=ignore' | Out-File -FilePath "ansible-infra-baseline\inventories\dev\hosts.ini" -Encoding UTF8

'common_users:
  - name: devops
    ssh_key: "ssh-ed25519 AAAA..."' | Out-File -FilePath "ansible-infra-baseline\group_vars\linux.yml" -Encoding UTF8

'# variáveis específicas de windows (placeholder)' | Out-File -FilePath "ansible-infra-baseline\group_vars\windows.yml" -Encoding UTF8

'- hosts: linux
  become: yes
  roles:
    - linux_hardening' | Out-File -FilePath "ansible-infra-baseline\playbooks\linux_hardening.yml" -Encoding UTF8

$ansibleTasks = @'
- name: Ensure ufw installed and enabled
  apt:
    name: ufw
    state: present
    update_cache: yes
  when: ansible_os_family == "Debian"

- name: Default deny incoming
  ufw:
    direction: incoming
    policy: deny
  when: ansible_os_family == "Debian"

- name: Allow SSH
  ufw:
    rule: allow
    port: '22'
    proto: tcp
  when: ansible_os_family == "Debian"

- name: Ensure common users exist
  user:
    name: "{{ item.name }}"
    state: present
    shell: /bin/bash
  loop: "{{ common_users }}"
'@
$ansibleTasks | Out-File -FilePath "ansible-infra-baseline\roles\linux_hardening\tasks\main.yml" -Encoding UTF8

'- hosts: windows
  gather_facts: no
  roles:
    - windows_updates' | Out-File -FilePath "ansible-infra-baseline\playbooks\windows_updates.yml" -Encoding UTF8

'- name: Instalar atualizações críticas
  win_updates:
    category_names:
      - CriticalUpdates
      - SecurityUpdates
    reboot: yes' | Out-File -FilePath "ansible-infra-baseline\roles\windows_updates\tasks\main.yml" -Encoding UTF8

'# Ansible Infra Baseline
Playbooks de baseline/hardening (Linux) e updates (Windows).

## Requisitos
- Ansible 2.15+
- Acesso SSH/WinRM

## Execução
```bash
ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml
ansible-playbook -i inventories/dev/hosts.ini playbooks/windows_updates.yml
```' | Out-File -FilePath "ansible-infra-baseline\README.md" -Encoding UTF8

Write-Host "✅ Ansible Infra Baseline criado" -ForegroundColor Green

# ===============================================
# 4) Zabbix + Grafana Starter
# ===============================================
Write-Host "`n📈 Criando Zabbix + Grafana Starter..." -ForegroundColor Cyan

'#!/usr/bin/env python3
import json
disks = [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]
print(json.dumps({"data": disks}))' | Out-File -FilePath "zabbix-grafana-starter\lld\disks_discovery.py" -Encoding UTF8

'{ "overwrite": true, "dashboard": { "title": "Infra Overview", "panels": [] } }' | Out-File -FilePath "zabbix-grafana-starter\grafana\infra_overview.json" -Encoding UTF8

'# Zabbix + Grafana Starter
Exemplo de LLD (descoberta de discos) e dashboard Grafana.

## Zabbix (LLD)
Crie um Item de descoberta que execute `lld/disks_discovery.py`

## Grafana
Importe `grafana/infra_overview.json` e ajuste o datasource.' | Out-File -FilePath "zabbix-grafana-starter\README.md" -Encoding UTF8

Write-Host "✅ Zabbix + Grafana Starter criado" -ForegroundColor Green

# ===============================================
# 5) Docker/K8s Microservice
# ===============================================
Write-Host "`n🐳 Criando Docker/K8s Microservice..." -ForegroundColor Cyan

'from flask import Flask
app = Flask(__name__)

@app.get("/health")
def health():
    return {"status":"ok"}

@app.get("/")
def home():
    return {"message":"hello from microservice"}' | Out-File -FilePath "docker-k8s-microservice\src\app.py" -Encoding UTF8

'flask==3.0.3' | Out-File -FilePath "docker-k8s-microservice\requirements.txt" -Encoding UTF8

'FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src src
EXPOSE 5000
CMD ["python","-m","flask","--app","src.app","run","--host=0.0.0.0"]' | Out-File -FilePath "docker-k8s-microservice\Dockerfile" -Encoding UTF8

'services:
  app:
    build: .
    ports:
      - "8080:5000"' | Out-File -FilePath "docker-k8s-microservice\docker-compose.yml" -Encoding UTF8

'apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-ms
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-ms
  template:
    metadata:
      labels:
        app: demo-ms
    spec:
      containers:
      - name: app
        image: romecyjr/demo-ms:latest
        ports:
        - containerPort: 5000' | Out-File -FilePath "docker-k8s-microservice\k8s\deployment.yaml" -Encoding UTF8

'apiVersion: v1
kind: Service
metadata:
  name: demo-ms
spec:
  type: ClusterIP
  selector:
    app: demo-ms
  ports:
  - port: 80
    targetPort: 5000' | Out-File -FilePath "docker-k8s-microservice\k8s\service.yaml" -Encoding UTF8

$dockerWorkflow = @'
name: Build
on:
  push:
    paths:
      - 'docker-k8s-microservice/**'
jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          context: docker-k8s-microservice
          push: false
          tags: romecyjr/demo-ms:latest
'@
$dockerWorkflow | Out-File -FilePath "docker-k8s-microservice\.github\workflows\build.yml" -Encoding UTF8

'# Docker/K8s Microservice
Microserviço Flask com `/health`, Dockerfile, Compose e manifests Kubernetes.

## Local
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python -m flask --app src.app run
# http://localhost:5000/health
```

## Docker
```bash
docker build -t demo-ms:local .
docker run -p 8080:5000 demo-ms:local
# http://localhost:8080/health
```

## Kubernetes
```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```' | Out-File -FilePath "docker-k8s-microservice\README.md" -Encoding UTF8

Write-Host "✅ Docker/K8s Microservice criado" -ForegroundColor Green

# ===============================================
# Git add/commit/push
# ===============================================
Write-Host "`n📝 Fazendo commit e push..." -ForegroundColor Cyan

git add .
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "feat(portfolio): adiciona 5 projetos, docs e CI"
    Write-Host "✅ Commit realizado!" -ForegroundColor Green

    git push -u origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ CONCLUÍDO! Repositório atualizado com sucesso!" -ForegroundColor Green
        Write-Host "🔗 Acesse: https://github.com/$REPO_OWNER/$REPO_NAME`n" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️  Erro no push. Verifique suas credenciais do GitHub." -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️  Nada para commitar." -ForegroundColor Yellow
}
