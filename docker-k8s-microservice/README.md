# Docker/K8s Microservice
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
```

## CI
Workflow `Build` pronto para publicar (configure `DOCKERHUB_USERNAME` e `DOCKERHUB_TOKEN` nos Secrets).
