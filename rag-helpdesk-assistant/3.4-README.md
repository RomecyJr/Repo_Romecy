# RAG Helpdesk Assistant
Assistente de base de conhecimento para Service Desk com **FastAPI + LangChain + FAISS**.

## Rodando local
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# http://localhost:8000/health
```

## Exemplo
```bash
curl -s -X POST localhost:8000/ask -H 'Content-Type: application/json' \
  -d '{"question":"Qual SLA de P1?"}'
```

## Docker
```bash
docker build -t rag-helpdesk:local .
docker run -p 8000:8000 rag-helpdesk:local
```

## CI
![CI](https://github.com/RomecyJr/Repo_Romecy/actions/workflows/ci.yml/badge.svg)

## Próximos passos
- Substituir FAISS por Chroma/Pinecone
- Observabilidade (Prometheus/OpenTelemetry)
- LangGraph para orquestração de etapas
