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
