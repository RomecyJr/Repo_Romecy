# 📊 Zabbix + Grafana Starter

![Status](https://img.shields.io/badge/status-active-success.svg)
![CI](https://github.com/OWNER/REPO/actions/workflows/stack-ci.yml/badge.svg)
![Docker](https://img.shields.io/badge/docker-compose-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Stack pronta para iniciar monitoração com Zabbix Server, Zabbix Agent, PostgreSQL, Grafana e dashboards pré-configurados.

## 🚀 Visão Geral

- Suba todo o stack com um único comando
- Dashboards Grafana para hosts Linux, Docker e rede
- Templates Zabbix importáveis para serviços comuns
- Coletores prontos (SNMP, Agent, HTTP checks)

## 🧱 Arquitetura
```
Docker Compose
├── zabbix-server (com DB Postgres)
├── zabbix-web
├── zabbix-agent
├── grafana
└── postgres
```

## ⚙️ Subindo o Stack

```bash
git clone https://github.com/RomecyJr/Repo_Romecy.git
cd zabbix-grafana-starter
docker compose up -d
```

Acesse:
- Zabbix Web: http://localhost:8080 (Admin / zabbix)
- Grafana: http://localhost:3000 (admin / admin)

![Zabbix Login](docs/screenshots/zabbix-login.png)
![Grafana Home](docs/screenshots/grafana-home.png)

## 🧩 Configuração Rápida

1) Adicionar host no Zabbix
- Vá em Configuration > Hosts > Create host
- Defina interface 10050/TCP para Agent
- Aplique template "Linux by Zabbix agent"

2) Data source Grafana
- Configure Prometheus/Zabbix datasource (via plugin alexanderzobnin-zabbix)
- Importe dashboard JSON em `grafana/dashboards/`

## 📦 Estrutura do Projeto
```
zabbix-grafana-starter/
├── docker-compose.yml
├── zabbix/
│   ├── alertscripts/
│   └── externalscripts/
├── grafana/
│   └── dashboards/
├── docs/
│   └── screenshots/
└── README.md
```

## 🧪 Testes Básicos

```bash
# Verificar containers
 docker ps

# Testar porta Zabbix Web
 curl -I http://localhost:8080

# Testar API Grafana
 curl -H "Authorization: Bearer <TOKEN>" http://localhost:3000/api/health
```

## 🧭 Roadmap
- [ ] Adicionar Zabbix proxy
- [ ] Dashboards para Kubernetes
- [ ] Auto-discovery de Docker hosts

## 📝 Licença
MIT License

---
Badges:
- ![CI](https://github.com/OWNER/REPO/actions/workflows/stack-ci.yml/badge.svg)

Última atualização: Outubro 2025
