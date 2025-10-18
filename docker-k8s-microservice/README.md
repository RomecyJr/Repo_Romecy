# 🧰 Docker + Kubernetes Microservice

![Status](https://img.shields.io/badge/status-active-success.svg)
![CI](https://github.com/OWNER/REPO/actions/workflows/build.yml/badge.svg)
![Docker](https://img.shields.io/badge/docker-ready-blue.svg)
![Kubernetes](https://img.shields.io/badge/k8s-manifests-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Exemplo completo de microserviço (Python FastAPI) com Docker, Helm Chart, manifests K8s, GitHub Actions e exemplos de observabilidade.

## ✨ Funcionalidades
- API FastAPI com endpoints REST e healthcheck
- Dockerfile multi-stage e docker-compose para dev
- Manifests K8s (Deployment, Service, Ingress) e Helm Chart
- GitHub Actions para build, testes e push de imagem
- Observabilidade: Prometheus metrics e logs estruturados

## 📂 Estrutura do Projeto
```
docker-k8s-microservice/
├── app/
│   ├── main.py
│   ├── api/
│   └── tests/
├── charts/
│   └── microservice/
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── .github/workflows/build.yml
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## 🚀 Início Rápido

### Local com Docker
```bash
docker build -t romecyjr/microservice:dev .
docker run -d -p 8080:8080 romecyjr/microservice:dev
curl http://localhost:8080/health
```

### Dev com docker-compose
```yaml
services:
  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      LOG_LEVEL: info
      PROMETHEUS_ENABLED: "true"
```

### Kubernetes (kubectl)
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
```

### Helm
```bash
helm install micro charts/microservice \
  --set image.repository=ghcr.io/romecyjr/microservice \
  --set image.tag=1.0.0
```

## 🧪 Testes
```bash
pytest -q
pytest --cov=app --cov-report=term-missing
```

## 🔧 Configuração

Variáveis de ambiente suportadas:
```env
PORT=8080
LOG_LEVEL=info
PROMETHEUS_ENABLED=true
ALLOWED_ORIGINS=*
```

## 🧩 CI/CD

GitHub Actions (`.github/workflows/build.yml`):
```yaml
name: Build & Test
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install -r requirements.txt
      - run: pytest
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}/microservice:latest
```

## 📈 Observabilidade
- Métricas Prometheus expostas em `/metrics`
- Healthcheck em `/health`
- Exemplos de logs em JSON

![K8s Deploy](docs/screenshots/k8s-deploy.png)
![API Resposta](docs/screenshots/api-response.png)

## 🧭 Roadmap
- [ ] Autoscaling (HPA)
- [ ] Canary releases (Argo Rollouts)
- [ ] Tracing (OpenTelemetry)

## 📝 Licença
MIT License

---
Badges:
- ![CI](https://github.com/OWNER/REPO/actions/workflows/build.yml/badge.svg)

Última atualização: Outubro 2025
