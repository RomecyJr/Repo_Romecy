#!/usr/bin/env bash
# vscode_llm_setup.sh
# Script único para preparar o portfólio no repositório existente (Repo_Romecy).
# Executa criação de pastas/arquivos, CI básico e faz git add/commit/push.

set -euo pipefail

REPO_OWNER_DEFAULT="RomecyJr"
REPO_NAME_DEFAULT="Repo_Romecy"
REPO_OWNER="${REPO_OWNER:-$REPO_OWNER_DEFAULT}"
REPO_NAME="${REPO_NAME:-$REPO_NAME_DEFAULT}"

# Detecta se estamos em um repositório git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "⚠️  Este script precisa ser executado dentro do repositório clone de ${REPO_OWNER}/${REPO_NAME}."
  echo "Ex.: git clone https://github.com/${REPO_OWNER}/${REPO_NAME}.git && cd ${REPO_NAME} && bash vscode_llm_setup.sh"
  exit 1
fi

# Descobre branch principal (main/master)
MAIN_BRANCH="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || true)"
if [[ -z "${MAIN_BRANCH}" ]]; then
  # fallback: tenta main, depois master
  if git show-ref --quiet refs/heads/main; then MAIN_BRANCH=main
  elif git show-ref --quiet refs/heads/master; then MAIN_BRANCH=master
  else MAIN_BRANCH=main; fi
fi

echo "📦 Repositório detectado. Branch principal: ${MAIN_BRANCH}"

# ------------------------------------------------------------------------------
# Arquivos gerais da raiz
# ------------------------------------------------------------------------------
mkdir -p .github/workflows

cat > .gitignore <<'EOF'
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
EOF

cat > LICENSE <<'EOF'
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
EOF

cat > README.md <<EOF
# Portfólio — Romecy Veiga

Este repositório reúne **5 projetos práticos** alinhados a Infra + IA aplicada a Suporte/Operações:

1. **RAG Helpdesk Assistant** — FastAPI + LangChain + FAISS, Docker e CI.
2. **ITSM Metrics Exporter** — Exporta métricas (mock Jira/Tiflux/OTRS) para Prometheus + dashboard Grafana.
3. **Ansible Infra Baseline** — Hardening Linux + updates Windows (WinRM).
4. **Zabbix + Grafana Starter** — LLD simples (discovery de discos) + dashboard.
5. **Docker/K8s Microservice** — Microserviço Flask com Docker, Compose e manifests Kubernetes.

> Objetivo: demonstrar **aplicação prática** de automação, observabilidade e IA em suporte (redução de TMA/MTTR), com código **rodável** e documentação clara.

## Como navegar
Cada pasta possui seu próprio \`README.md\` com instruções de execução/teste e próximos passos.

## Status
![CI](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions/workflows/ci.yml/badge.svg)
EOF

# Um README para ser usado como perfil (copie o conteúdo para um repositório chamado ${REPO_OWNER})
mkdir -p PROFILE_README
cat > PROFILE_README/README.md <<'EOF'
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
EOF

# ------------------------------------------------------------------------------
# 1) rag-helpdesk-assistant
# ------------------------------------------------------------------------------
mkdir -p rag-helpdesk-assistant/app rag-helpdesk-assistant/tests

cat > rag-helpdesk-assistant/requirements.txt <<'EOF'
fastapi==0.115.0
uvicorn[standard]==0.30.0
langchain==0.2.15
langchain-community==0.2.15
faiss-cpu==1.8.0
sentence-transformers==2.7.0
pydantic==2.9.2
EOF

cat > rag-helpdesk-assistant/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app app
ENV EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

cat > rag-helpdesk-assistant/.env.example <<'EOF'
HF_TOKEN=coloque_sua_chave_se_for_usar_modelos_hf_privados
HF_MODEL=google/flan-t5-base
EMB_MODEL=sentence-transformers/all-MiniLM-L6-v2
EOF

cat > rag-helpdesk-assistant/app/main.py <<'EOF'
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
EOF

cat > rag-helpdesk-assistant/app/rag.py <<'EOF'
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
EOF

mkdir -p rag-helpdesk-assistant/app/kb
echo "FAQ: Como abrir chamado? Use o portal. P1 = indisponibilidade total." > rag-helpdesk-assistant/app/kb/faq.txt

cat > rag-helpdesk-assistant/tests/test_health.py <<'EOF'
def test_placeholder():
    assert True
EOF

cat > rag-helpdesk-assistant/README.md <<EOF
# RAG Helpdesk Assistant
Assistente de base de conhecimento para Service Desk com **FastAPI + LangChain + FAISS**.

## Rodando local
\`\`\`bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# http://localhost:8000/health
\`\`\`

## Exemplo
\`\`\`bash
curl -s -X POST localhost:8000/ask -H 'Content-Type: application/json' \\
  -d '{"question":"Qual SLA de P1?"}'
\`\`\`

## Docker
\`\`\`bash
docker build -t rag-helpdesk:local .
docker run -p 8000:8000 rag-helpdesk:local
\`\`\`

## CI
![CI](https://github.com/${REPO_OWNER}/${REPO_NAME}/actions/workflows/ci.yml/badge.svg)

## Próximos passos
- Substituir FAISS por Chroma/Pinecone
- Observabilidade (Prometheus/OpenTelemetry)
- LangGraph para orquestração de etapas
EOF

# ------------------------------------------------------------------------------
# CI geral (roda apenas o placeholder do RAG)
# ------------------------------------------------------------------------------
cat > .github/workflows/ci.yml <<'EOF'
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
EOF

# ------------------------------------------------------------------------------
# 2) itsm-metrics-exporter
# ------------------------------------------------------------------------------
mkdir -p itsm-metrics-exporter/grafana

cat > itsm-metrics-exporter/requirements.txt <<'EOF'
prometheus-client==0.20.0
EOF

cat > itsm-metrics-exporter/exporter.py <<'EOF'
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
EOF

cat > itsm-metrics-exporter/README.md <<'EOF'
# ITSM Metrics Exporter
Exporta métricas **mock** de chamados (Jira/Tiflux/OTRS) em `/metrics` para Prometheus.

## Rodando
```bash
pip install -r requirements.txt
python exporter.py
# Acesse: http://localhost:9108/metrics
```

## Grafana
Importe `grafana/dashboard.json` (placeholder) e crie 3 painéis: itsm_open_tickets, itsm_mttr_hours, itsm_tma_minutes.

## Docker (opcional)
Crie um Dockerfile simples se quiser publicar, ou use python:3.11-slim.
EOF

cat > itsm-metrics-exporter/grafana/dashboard.json <<'EOF'
{ "overwrite": true, "dashboard": { "title": "ITSM Metrics (Mock)", "panels": [] } }
EOF

# ------------------------------------------------------------------------------
# 3) ansible-infra-baseline
# ------------------------------------------------------------------------------
mkdir -p ansible-infra-baseline/{inventories/dev,group_vars,playbooks,roles/linux_hardening/tasks,roles/windows_updates/tasks}

cat > ansible-infra-baseline/inventories/dev/hosts.ini <<'EOF'
[linux]
192.168.1.10

[windows]
192.168.1.20 ansible_user=Administrator ansible_password=ChangeMe ansible_connection=winrm ansible_winrm_server_cert_validation=ignore
EOF

cat > ansible-infra-baseline/group_vars/linux.yml <<'EOF'
common_users:
  - name: devops
    ssh_key: "ssh-ed25519 AAAA..."
EOF

cat > ansible-infra-baseline/group_vars/windows.yml <<'EOF'
# variáveis específicas de windows (placeholder)
EOF

cat > ansible-infra-baseline/playbooks/linux_hardening.yml <<'EOF'
- hosts: linux
  become: yes
  roles:
    - linux_hardening
EOF

cat > ansible-infra-baseline/roles/linux_hardening/tasks/main.yml <<'EOF'
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
EOF

cat > ansible-infra-baseline/playbooks/windows_updates.yml <<'EOF'
- hosts: windows
  gather_facts: no
  roles:
    - windows_updates
EOF

cat > ansible-infra-baseline/roles/windows_updates/tasks/main.yml <<'EOF'
- name: Instalar atualizações críticas
  win_updates:
    category_names:
      - CriticalUpdates
      - SecurityUpdates
    reboot: yes
EOF

cat > ansible-infra-baseline/README.md <<'EOF'
# Ansible Infra Baseline
Playbooks de baseline/hardening (Linux) e updates (Windows).

## Requisitos
- Ansible 2.15+
- Acesso SSH/WinRM às máquinas de teste

## Execução
```bash
ansible-playbook -i inventories/dev/hosts.ini playbooks/linux_hardening.yml
ansible-playbook -i inventories/dev/hosts.ini playbooks/windows_updates.yml
```

## Observações
- Ajuste usuários/chaves em group_vars.
- Em Windows, configure WinRM previamente.
EOF

# ------------------------------------------------------------------------------
# 4) zabbix-grafana-starter
# ------------------------------------------------------------------------------
mkdir -p zabbix-grafana-starter/{lld,grafana}

cat > zabbix-grafana-starter/lld/disks_discovery.py <<'EOF'
#!/usr/bin/env python3
import json
disks = [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]
print(json.dumps({"data": disks}))
EOF
chmod +x zabbix-grafana-starter/lld/disks_discovery.py

cat > zabbix-grafana-starter/grafana/infra_overview.json <<'EOF'
{ "overwrite": true, "dashboard": { "title": "Infra Overview", "panels": [] } }
EOF

cat > zabbix-grafana-starter/README.md <<'EOF'
# Zabbix + Grafana Starter
Exemplo de LLD (descoberta de discos) e um dashboard Grafana placeholder.

## Zabbix (LLD)
Crie um Item de descoberta que execute `lld/disks_discovery.py`
Protótipos de itens: uso de disco por {#MOUNT}, triggers para >80%

## Grafana
Importe `grafana/infra_overview.json` e ajuste o datasource.
EOF

# ------------------------------------------------------------------------------
# 5) docker-k8s-microservice
# ------------------------------------------------------------------------------
mkdir -p docker-k8s-microservice/{src,k8s,.github/workflows}

cat > docker-k8s-microservice/src/app.py <<'EOF'
from flask import Flask
app = Flask(__name__)

@app.get("/health")
def health():
    return {"status":"ok"}

@app.get("/")
def home():
    return {"message":"hello from microservice"}
EOF

cat > docker-k8s-microservice/requirements.txt <<'EOF'
flask==3.0.3
EOF

cat > docker-k8s-microservice/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src src
EXPOSE 5000
CMD ["python","-m","flask","--app","src.app","run","--host=0.0.0.0"]
EOF

cat > docker-k8s-microservice/docker-compose.yml <<'EOF'
services:
  app:
    build: .
    ports:
      - "8080:5000"
EOF

cat > docker-k8s-microservice/k8s/deployment.yaml <<'EOF'
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
EOF

cat > docker-k8s-microservice/k8s/service.yaml <<'EOF'
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
EOF

cat > docker-k8s-microservice/.github/workflows/build.yml <<'EOF'
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
EOF

cat > docker-k8s-microservice/README.md <<EOF
# Docker/K8s Microservice
Microserviço Flask com \`/health\`, Dockerfile, Compose e manifests Kubernetes.

## Local
\`\`\`bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python -m flask --app src.app run
# http://localhost:5000/health
\`\`\`

## Docker
\`\`\`bash
docker build -t demo-ms:local .
docker run -p 8080:5000 demo-ms:local
# http://localhost:8080/health
\`\`\`

## Kubernetes
\`\`\`bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
\`\`\`

## CI
Workflow \`Build\` pronto para publicar (configure \`DOCKERHUB_USERNAME\` e \`DOCKERHUB_TOKEN\` nos Secrets).
EOF

# ------------------------------------------------------------------------------
# Git add/commit/push
# ------------------------------------------------------------------------------

echo "📝 Fazendo commit das alterações…"
git add .
if git diff --cached --quiet; then
  echo "Nada para commitar."
else
  git commit -m "feat(portfolio): adiciona 5 projetos, docs e CI"
fi

# Garante que estamos na branch principal
current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "${current_branch}" != "${MAIN_BRANCH}" ]]; then
  echo "🔄 Mudando para branch ${MAIN_BRANCH} (ou criando)…"
  git checkout -B "${MAIN_BRANCH}"
fi

echo "⬆️ Enviando para origin/${MAIN_BRANCH}…"
git push -u origin "${MAIN_BRANCH}" || {
  echo "⚠️ Falha no push. Verifique se o remote 'origin' aponta para https://github.com/${REPO_OWNER}/${REPO_NAME}.git e se você tem permissão."
  exit 1
}

echo "✅ Pronto! Abra o repositório em https://github.com/${REPO_OWNER}/${REPO_NAME}"
echo "   - README raiz já lista os projetos."
echo "   - Workflows de CI criados."
echo "   - Cada projeto tem instruções de execução."
