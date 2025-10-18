# Portfólio — Romecy Veiga

Este monorepositório reúne projetos práticos de **Infra + IA aplicada a Suporte/Operações**.
Cada projeto fica em `projetos/<nome>` com seu próprio `README.md`, testes e scripts.

## 🚀 Projetos
- **RAG Helpdesk Assistant** — FastAPI + LangChain + FAISS, Docker e CI.
- **ITSM Metrics Exporter** — Exporta métricas mock (Jira/Tiflux/OTRS) para Prometheus + dashboard Grafana.
- **Ansible Infra Baseline** — Hardening Linux + updates Windows (WinRM).
- **Zabbix + Grafana Starter** — LLD simples (discovery de discos) + dashboard.
- **Docker/K8s Microservice** — Microserviço Flask com Docker, Compose e manifests Kubernetes.

> Consulte `docs/indice.md` para navegação detalhada.

## 🧰 Como rodar localmente
```bash
pipx install pre-commit || pip install pre-commit
pre-commit install
```

## 📐 Padrões do repositório

- Nomes de arquivos/pastas em kebab-case e sem acentos.
- Quebra de linha LF, indentação consistente (EditorConfig).
- Markdown validado por markdownlint.
- Ortografia pt-BR por cspell.
- Commits em Conventional Commits (ver CONTRIBUTING.md).

## 📄 Licença

MIT — veja LICENÇA.
