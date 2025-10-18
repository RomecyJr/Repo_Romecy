# 📈 ITSM Metrics Exporter

![Status](https://img.shields.io/badge/status-active-success.svg)
![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)
![Docker](https://img.shields.io/badge/docker-ready-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📋 Sobre o Projeto

O **ITSM Metrics Exporter** coleta métricas de plataformas ITSM (ServiceNow, Jira Service Management, GLPI, Freshservice) e expõe em formato Prometheus, permitindo a criação de dashboards no Grafana e alertas proativos sobre SLAs, backlog, throughput e saúde operacional.

### 🔥 Destaques
- Exporta métricas padronizadas para Prometheus
- Suporte a múltiplos provedores ITSM via plugins
- Configuração via YAML e variáveis de ambiente
- Container Docker leve, pronto para produção

## 🧱 Arquitetura

```
┌─────────────┐     ┌──────────────┐     ┌───────────────┐
│ ITSM APIs   │ --> │ Exporter API │ --> │ Prometheus     │
│ (SNOW/JSM)  │     │ (/metrics)   │     │ (scrape)       │
└─────────────┘     └──────────────┘     └───────────────┘
                                     ↘   ┌───────────────┐
                                       → │ Grafana       │
                                         └───────────────┘
```

## 🚀 Início Rápido

### Usando Docker
```bash
docker run -d \
  -p 9800:9800 \
  -e PROVIDER=servicenow \
  -e SNOW_INSTANCE=acme \
  -e SNOW_USER=api_user \
  -e SNOW_PASSWORD=secret \
  ghcr.io/romecyjr/itsm-metrics-exporter:latest
```

Acesse: http://localhost:9800/metrics

### Usando Docker Compose
```yaml
services:
  exporter:
    image: ghcr.io/romecyjr/itsm-metrics-exporter:latest
    ports:
      - "9800:9800"
    environment:
      PROVIDER: servicenow
      SNOW_INSTANCE: acme
      SNOW_USER: ${SNOW_USER}
      SNOW_PASSWORD: ${SNOW_PASSWORD}
```

### Execução Local (Python)
```bash
pip install -r requirements.txt
export PROVIDER=jira
export JIRA_URL=https://acme.atlassian.net
export JIRA_EMAIL=ops@acme.com
export JIRA_API_TOKEN=xxxx
uvicorn exporter.main:app --port 9800
```

## 📡 Métricas Expostas

- `itsm_tickets_open_total{queue=...,priority=...}`
- `itsm_sla_breached_total{queue=...}`
- `itsm_resolution_time_seconds_bucket{queue=...,le=...}`
- `itsm_throughput_tickets_per_day`
- `itsm_backlog_age_days_avg`

![Exemplo de Métricas](docs/screenshots/metrics-endpoint.png)

## 📊 Dashboards Grafana

Importe o dashboard JSON em `grafana/dashboards/itsm_overview.json`.

![Dashboard ITSM](docs/screenshots/grafana-itsm.png)

## 🔧 Configuração

Crie `config/config.yaml`:
```yaml
provider: servicenow
servicenow:
  instance: acme
  user: ${SNOW_USER}
  password: ${SNOW_PASSWORD}
  tables:
    - incident
    - problem
    - change_request
  query_window_days: 30
server:
  host: 0.0.0.0
  port: 9800
```

Variáveis de ambiente suportadas:

```env
PROVIDER=jira|servicenow|glpi|freshservice
POLL_INTERVAL=60
LOG_LEVEL=INFO
CACHE_TTL=120
```

## 🧩 Plugins de Provedores

- ServiceNow: `exporter/providers/servicenow.py`
- Jira Service Management: `exporter/providers/jira.py`
- GLPI: `exporter/providers/glpi.py`
- Freshservice: `exporter/providers/freshservice.py`

## 🔒 Segurança

- Credenciais via variáveis de ambiente ou secret manager
- TLS/HTTPS atrás de um reverse proxy (Traefik/Nginx)
- Rate limiting e backoff exponencial nas APIs

## 🧪 Testes
```bash
pytest
pytest --cov=exporter --cov-report=term-missing
```

## 📦 Estrutura do Projeto
```
itsm-metrics-exporter/
├── exporter/
│   ├── main.py
│   ├── metrics.py
│   ├── providers/
│   └── utils/
├── grafana/
│   └── dashboards/
├── docs/
│   └── screenshots/
├── docker/
├── requirements.txt
└── README.md
```

## 🤝 Contribuição

1. Crie uma issue para discutir mudanças
2. Abra um PR com descrição clara
3. Inclua testes e atualização de docs

## 🧭 Roadmap

- [ ] Suporte a Cherwell e BMC Helix
- [ ] Filtros por filas e grupos
- [ ] Export de SLIs/SLOs

## 🏷️ Licença

MIT License.

---

CI Badges:

- GitHub Actions: ![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)
- Docker Image: ![Docker](https://img.shields.io/docker/pulls/romecyjr/itsm-metrics-exporter)

Última atualização: Outubro 2025
