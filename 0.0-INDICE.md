# 📚 Índice de Documentação - Portfolio Romecy

> **Sistema de Numeração Hierárquica**
> Formato: `[Seção].[Subseção]-nome-arquivo.md`

---

## 📖 Estrutura da Documentação

### 1. Documentação Principal
- **[1.0 - README Principal](1.0-README.md)**
  Visão geral do portfólio e apresentação

- **[1.1 - Comece Aqui](1.1-comece-aqui.md)**
  Guia de início rápido e primeiros passos com testes

- **[1.2 - Explicação dos Projetos](1.2-explicacao-projetos.md)**
  Detalhamento completo de cada projeto do portfólio

---

### 2. Guias e Tutoriais
- **[2.0 - Guia de Testes](2.0-guia-de-testes.md)**
  Como executar e validar os testes dos projetos

- **[2.1 - Instruções Git](2.1-instrucoes-git.md)**
  Comandos Git e fluxo de trabalho recomendado

- **[2.2 - README Testes](2.2-readme-testes.md)**
  Documentação específica sobre testes automatizados

---

### 3. Projetos

#### 3.1 - Ansible Infrastructure Baseline
- **[3.1 - README](ansible-infra-baseline/3.1-README.md)**
- **Objetivo:** Automação de hardening Linux/Windows
- **Stack:** Ansible, YAML
- **Pasta:** `ansible-infra-baseline/`

#### 3.2 - Docker & Kubernetes Microservice
- **[3.2 - README](docker-k8s-microservice/3.2-README.md)**
- **Objetivo:** API Flask containerizada com orquestração K8s
- **Stack:** Docker, Kubernetes, Python/Flask
- **Pasta:** `docker-k8s-microservice/`

#### 3.3 - ITSM Metrics Exporter
- **[3.3 - README](itsm-metrics-exporter/3.3-README.md)**
- **Objetivo:** Exportador Prometheus para métricas de ServiceNow
- **Stack:** Python, Prometheus, Grafana
- **Pasta:** `itsm-metrics-exporter/`

#### 3.4 - RAG Helpdesk Assistant
- **[3.4 - README](rag-helpdesk-assistant/3.4-README.md)**
- **Objetivo:** Assistente inteligente com RAG para helpdesk
- **Stack:** Python, FastAPI, LangChain, ChromaDB
- **Pasta:** `rag-helpdesk-assistant/`

#### 3.5 - Zabbix & Grafana Starter
- **[3.5 - README](zabbix-grafana-starter/3.5-README.md)**
- **Objetivo:** Template de monitoramento de infraestrutura
- **Stack:** Zabbix, Grafana, Python
- **Pasta:** `zabbix-grafana-starter/`

---

## 🗂️ Estrutura de Diretórios

```
Repo_Romecy/
│
├── 1.0-README.md                    ← Entrada principal
├── 1.1-comece-aqui.md              ← Start here!
├── 1.2-explicacao-projetos.md      ← Visão geral dos projetos
├── 2.0-guia-de-testes.md           ← Como testar
├── 2.1-instrucoes-git.md           ← Comandos Git
├── 2.2-readme-testes.md            ← Testes detalhados
│
├── ansible-infra-baseline/
│   ├── 3.1-README.md               ← Docs do projeto
│   ├── playbooks/
│   └── roles/
│
├── docker-k8s-microservice/
│   ├── 3.2-README.md
│   ├── Dockerfile
│   ├── k8s/
│   └── src/
│
├── itsm-metrics-exporter/
│   ├── 3.3-README.md
│   ├── exporter.py
│   └── grafana/
│
├── rag-helpdesk-assistant/
│   ├── 3.4-README.md
│   ├── app/
│   └── tests/
│
└── zabbix-grafana-starter/
    ├── 3.5-README.md
    ├── grafana/
    └── lld/
```

---

## 🎯 Navegação Rápida

| Precisa de... | Vá para |
|---------------|---------|
| Começar do zero | [1.1 - Comece Aqui](1.1-comece-aqui.md) |
| Entender os projetos | [1.2 - Explicação](1.2-explicacao-projetos.md) |
| Rodar testes | [2.0 - Guia de Testes](2.0-guia-de-testes.md) |
| Contribuir via Git | [2.1 - Instruções Git](2.1-instrucoes-git.md) |
| Ver projeto específico | Seção 3 (acima) |

---

## 📝 Convenções de Nomenclatura

- **1.x** = Documentação introdutória e principal
- **2.x** = Guias técnicos e tutoriais
- **3.x** = Documentação específica de projetos
- **4.x** = Arquitetura e design (futuro)
- **5.x** = APIs e referências (futuro)

---

## 🔄 Última Atualização

**Data:** 18 de outubro de 2025
**Versão:** 1.0
**Mantido por:** RomecyJr

---

**💡 Dica:** Favoritar este arquivo para navegação rápida!
