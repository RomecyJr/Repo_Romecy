# vscode_llm_setup.ps1
# Script PowerShell para preparar o portfólio no repositório Repo_Romecy
# Versão Windows nativa (não requer bash)

$ErrorActionPreference = "Continue"

$REPO_OWNER = "RomecyJr"
$REPO_NAME = "Repo_Romecy"

Write-Host "📦 Verificando repositório Git..." -ForegroundColor Cyan

# Verifica se está em um repositório git
try {
    git rev-parse --is-inside-work-tree 2>&1 | Out-Null
} catch {
    Write-Host "⚠️  Este script precisa ser executado dentro do repositório $REPO_OWNER/$REPO_NAME" -ForegroundColor Red
    exit 1
}

# Descobre branch principal
$MAIN_BRANCH = git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>$null
if ($MAIN_BRANCH) {
    $MAIN_BRANCH = $MAIN_BRANCH -replace '^origin/', ''
} else {
    $MAIN_BRANCH = "main"
}

Write-Host "📦 Repositório detectado. Branch principal: $MAIN_BRANCH" -ForegroundColor Green

# ------------------------------------------------------------------------------
# Arquivos gerais da raiz
# ------------------------------------------------------------------------------
Write-Host "📁 Criando estrutura de pastas..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path ".github/workflows" | Out-Null

# .gitignore
@"
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
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# LICENSE
@"
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
"@ | Set-Content -Path "LICENSE" -Encoding UTF8

# README.md principal
@"
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
"@ | Set-Content -Path "README.md" -Encoding UTF8

# PROFILE_README
New-Item -ItemType Directory -Force -Path "PROFILE_README" | Out-Null
@"
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
"@ | Set-Content -Path "PROFILE_README/README.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 1) rag-helpdesk-assistant
# ------------------------------------------------------------------------------
Write-Host "🤖 Criando projeto RAG Helpdesk Assistant..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "rag-helpdesk-assistant/app" | Out-Null
New-Item -ItemType Directory -Force -Path "rag-helpdesk-assistant/tests" | Out-Null
New-Item -ItemType Directory -Force -Path "rag-helpdesk-assistant/app/kb" | Out-Null

@"
fastapi==0.115.0
uvicorn[standard]==0.30.0
langchain==0.2.15
langchain-community==0.2.15
faiss-cpu==1.8.0
sentence-transformers==2.7.0
pydantic==2.9.2
"@ | Set-Content -Path "rag-helpdesk-assistant/requirements.txt" -Encoding UTF8

@"
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app app
ENV EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
"@ | Set-Content -Path "rag-helpdesk-assistant/Dockerfile" -Encoding UTF8

@"
HF_TOKEN=coloque_sua_chave_se_for_usar_modelos_hf_privados
HF_MODEL=google/flan-t5-base
EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2
"@ | Set-Content -Path "rag-helpdesk-assistant/.env.example" -Encoding UTF8

@"
from fastapi import FastAPI
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
    return {"answer": answer_query(payload.question)}
"@ | Set-Content -Path "rag-helpdesk-assistant/app/main.py" -Encoding UTF8

@"
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
"@ | Set-Content -Path "rag-helpdesk-assistant/app/rag.py" -Encoding UTF8

"FAQ: Como abrir chamado? Use o portal. P1 = indisponibilidade total." | Set-Content -Path "rag-helpdesk-assistant/app/kb/faq.txt" -Encoding UTF8

@"
def test_placeholder():
    assert True
"@ | Set-Content -Path "rag-helpdesk-assistant/tests/test_health.py" -Encoding UTF8

@"
# RAG Helpdesk Assistant
Assistente de base de conhecimento para Service Desk com **FastAPI + LangChain + FAISS**.

## Rodando local
``````bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# http://localhost:8000/health
``````

## Exemplo
``````bash
curl -s -X POST localhost:8000/ask -H 'Content-Type: application/json' \
  -d '{\"question\":\"Qual SLA de P1?\"}'
``````

## Docker
``````bash
docker build -t rag-helpdesk:local .
docker run -p 8000:8000 rag-helpdesk:local
``````

## CI
![CI](https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/ci.yml/badge.svg)

## Próximos passos
- Substituir FAISS por Chroma/Pinecone
- Observabilidade (Prometheus/OpenTelemetry)
- LangGraph para orquestração de etapas
"@ | Set-Content -Path "rag-helpdesk-assistant/README.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# CI Workflow
# ------------------------------------------------------------------------------
@"
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
"@ | Set-Content -Path ".github/workflows/ci.yml" -Encoding UTF8

# ------------------------------------------------------------------------------
# 2) itsm-metrics-exporter
# ------------------------------------------------------------------------------
Write-Host "📊 Criando projeto ITSM Metrics Exporter..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "itsm-metrics-exporter/grafana" | Out-Null

@"
prometheus-client==0.20.0
"@ | Set-Content -Path "itsm-metrics-exporter/requirements.txt" -Encoding UTF8

@"
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
"@ | Set-Content -Path "itsm-metrics-exporter/exporter.py" -Encoding UTF8

@"
# ITSM Metrics Exporter
Exporta métricas **mock** de chamados (Jira/Tiflux/OTRS) em ``/metrics`` para Prometheus.

## Rodando
``````bash
pip install -r requirements.txt
python exporter.py
# Acesse: http://localhost:9108/metrics
``````

## Grafana
Importe ``grafana/dashboard.json`` (placeholder) e crie 3 painéis: itsm_open_tickets, itsm_mttr_hours, itsm_tma_minutes.

## Docker (opcional)
Crie um Dockerfile simples se quiser publicar, ou use python:3.11-slim.
"@ | Set-Content -Path "itsm-metrics-exporter/README.md" -Encoding UTF8

'{ "overwrite": true, "dashboard": { "title": "ITSM Metrics (Mock)", "panels": [] } }' | Set-Content -Path "itsm-metrics-exporter/grafana/dashboard.json" -Encoding UTF8

# ------------------------------------------------------------------------------
# 3) ansible-infra-baseline
# ------------------------------------------------------------------------------
Write-Host "⚙️  Criando projeto Ansible Infra Baseline..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "ansible-infra-baseline/inventories/dev" | Out-Null
New-Item -ItemType Directory -Force -Path "ansible-infra-baseline/group_vars" | Out-Null
New-Item -ItemType Directory -Force -Path "ansible-infra-baseline/playbooks" | Out-Null
New-Item -ItemType Directory -Force -Path "ansible-infra-baseline/roles/linux_hardening/tasks" | Out-Null
New-Item -ItemType Directory -Force -Path "ansible-infra-baseline/roles/windows_updates/tasks" | Out-Null

@"
[linux]
192.168.1.10

[windows]
192.168.1.20 ansible_user=Administrator ansible_password=ChangeMe ansible_connection=winrm ansible_winrm_server_cert_validation=ignore
"@ | Set-Content -Path "ansible-infra-baseline/inventories/dev/hosts.ini" -Encoding UTF8

@"
common_users:
  - name: devops
    ssh_key: "ssh-ed25519 AAAA..."
"@ | Set-Content -Path "ansible-infra-baseline/group_vars/linux.yml" -Encoding UTF8

"# variáveis específicas de windows (placeholder)" | Set-Content -Path "ansible-infra-baseline/group_vars/windows.yml" -Encoding UTF8

@"
- hosts: linux
  become: yes
  roles:
    - linux_hardening
"@ | Set-Content -Path "ansible-infra-baseline/playbooks/linux_hardening.yml" -Encoding UTF8

@"
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
"@ | Set-Content -Path "ansible-infra-baseline/roles/linux_hardening/tasks/main.yml" -Encoding UTF8

@"
- hosts: windows
  gather_facts: no
  roles:
    - windows_updates
"@ | Set-Content -Path "ansible-infra-baseline/playbooks/windows_updates.yml" -Encoding UTF8

@"
- name: Instalar atualizações críticas
  win_updates:
    category_names:
      - CriticalUpdates
      - SecurityUpdates
    reboot: yes
"@ | Set-Content -Path "ansible-infra-baseline/roles/windows_updates/tasks/main.yml" -Encoding UTF8

@"
# Ansible Infra Baseline
Playbooks de baseline/hardening (Linux) e updates (Windows).

## Requisitos
- Ansible 2.15+
- Acesso SSH/WinRM às máquinas de teste

## Execução
``````bash
ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml
ansible-playbook -i inventories/dev/hosts.ini playbooks/windows_updates.yml
``````

## Observações
- Ajuste usuários/chaves em group_vars.
- Em Windows, configure WinRM previamente.
"@ | Set-Content -Path "ansible-infra-baseline/README.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 4) zabbix-grafana-starter
# ------------------------------------------------------------------------------
Write-Host "📈 Criando projeto Zabbix + Grafana Starter..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "zabbix-grafana-starter/lld" | Out-Null
New-Item -ItemType Directory -Force -Path "zabbix-grafana-starter/grafana" | Out-Null

@"
#!/usr/bin/env python3
import json
disks = [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]
print(json.dumps({"data": disks}))
"@ | Set-Content -Path "zabbix-grafana-starter/lld/disks_discovery.py" -Encoding UTF8

'{ "overwrite": true, "dashboard": { "title": "Infra Overview", "panels": [] } }' | Set-Content -Path "zabbix-grafana-starter/grafana/infra_overview.json" -Encoding UTF8

@"
# Zabbix + Grafana Starter
Exemplo de LLD (descoberta de discos) e um dashboard Grafana placeholder.

## Zabbix (LLD)
Crie um Item de descoberta que execute ``lld/disks_discovery.py``
Protótipos de itens: uso de disco por {#MOUNT}, triggers para >80%

## Grafana
Importe ``grafana/infra_overview.json`` e ajuste o datasource.
"@ | Set-Content -Path "zabbix-grafana-starter/README.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 5) docker-k8s-microservice
# ------------------------------------------------------------------------------
Write-Host "🐳 Criando projeto Docker/K8s Microservice..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "docker-k8s-microservice/src" | Out-Null
New-Item -ItemType Directory -Force -Path "docker-k8s-microservice/k8s" | Out-Null
New-Item -ItemType Directory -Force -Path "docker-k8s-microservice/.github/workflows" | Out-Null

@"
from flask import Flask
app = Flask(__name__)

@app.get("/health")
def health():
    return {"status":"ok"}

@app.get("/")
def home():
    return {"message":"hello from microservice"}
"@ | Set-Content -Path "docker-k8s-microservice/src/app.py" -Encoding UTF8

"flask==3.0.3" | Set-Content -Path "docker-k8s-microservice/requirements.txt" -Encoding UTF8

@"
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src src
EXPOSE 5000
CMD ["python","-m","flask","--app","src.app","run","--host=0.0.0.0"]
"@ | Set-Content -Path "docker-k8s-microservice/Dockerfile" -Encoding UTF8

@"
services:
  app:
    build: .
    ports:
      - "8080:5000"
"@ | Set-Content -Path "docker-k8s-microservice/docker-compose.yml" -Encoding UTF8

@"
apiVersion: apps/v1
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
        - containerPort: 5000
"@ | Set-Content -Path "docker-k8s-microservice/k8s/deployment.yaml" -Encoding UTF8

@"
apiVersion: v1
kind: Service
metadata:
  name: demo-ms
spec:
  type: ClusterIP
  selector:
    app: demo-ms
  ports:
  - port: 80
    targetPort: 5000
"@ | Set-Content -Path "docker-k8s-microservice/k8s/service.yaml" -Encoding UTF8

@"
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
          username: `${{ secrets.DOCKERHUB_USERNAME }}
          password: `${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          context: docker-k8s-microservice
          push: false
          tags: romecyjr/demo-ms:latest
"@ | Set-Content -Path "docker-k8s-microservice/.github/workflows/build.yml" -Encoding UTF8

@"
# Docker/K8s Microservice
Microserviço Flask com ``/health``, Dockerfile, Compose e manifests Kubernetes.

## Local
``````bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python -m flask --app src.app run
# http://localhost:5000/health
``````

## Docker
``````bash
docker build -t demo-ms:local .
docker run -p 8080:5000 demo-ms:local
# http://localhost:8080/health
``````

## Kubernetes
``````bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
``````

## CI
Workflow ``Build`` pronto para publicar (configure ``DOCKERHUB_USERNAME`` e ``DOCKERHUB_TOKEN`` nos Secrets).
"@ | Set-Content -Path "docker-k8s-microservice/README.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# Git add/commit/push
# ------------------------------------------------------------------------------
Write-Host "`n📝 Fazendo commit das alterações..." -ForegroundColor Cyan

git add .

git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "feat(portfolio): adiciona 5 projetos, docs e CI"
    Write-Host "✅ Commit realizado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Nada para commitar." -ForegroundColor Yellow
}

# Garante que estamos na branch principal
$current_branch = git rev-parse --abbrev-ref HEAD
if ($current_branch -ne $MAIN_BRANCH) {
    Write-Host "🔄 Mudando para branch $MAIN_BRANCH..." -ForegroundColor Cyan
    git checkout -B $MAIN_BRANCH
}

Write-Host "⬆️  Enviando para origin/$MAIN_BRANCH..." -ForegroundColor Cyan
git push -u origin $MAIN_BRANCH
if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Pronto! Abra o repositório em https://github.com/$REPO_OWNER/$REPO_NAME" -ForegroundColor Green
    Write-Host "   - README raiz já lista os projetos." -ForegroundColor Cyan
    Write-Host "   - Workflows de CI criados." -ForegroundColor Cyan
    Write-Host "   - Cada projeto tem instruções de execução.`n" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Falha no push. Verifique suas credenciais e permissões." -ForegroundColor Red
    Write-Host "    Remote: https://github.com/$REPO_OWNER/$REPO_NAME.git" -ForegroundColor Yellow
}
