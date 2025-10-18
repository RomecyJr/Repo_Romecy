# 🤖 RAG Helpdesk Assistant

![Status](https://img.shields.io/badge/status-active-success.svg)
![CI/CD](https://img.shields.io/badge/CI-passing-brightgreen.svg)
![Python](https://img.shields.io/badge/python-3.9+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📋 Sobre o Projeto

O **RAG Helpdesk Assistant** é um assistente inteligente de helpdesk que utiliza Retrieval-Augmented Generation (RAG) para fornecer respostas precisas e contextualizadas baseadas em documentação técnica e base de conhecimento.

### 🎯 Principais Funcionalidades

- ✅ Busca semântica em base de conhecimento
- ✅ Geração de respostas contextualizadas usando LLM
- ✅ Integração com sistemas de ticket (Jira, ServiceNow)
- ✅ Suporte multilíngue (português, inglês, espanhol)
- ✅ Interface web amigável
- ✅ API REST para integrações

## 🏗️ Arquitetura

```
┌─────────────────┐
│   Frontend      │
│   (React)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   API Gateway   │
│   (FastAPI)     │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌──────┐  ┌──────────┐
│Vector│  │   LLM    │
│  DB  │  │ (OpenAI) │
└──────┘  └──────────┘
```

## 🚀 Início Rápido

### Pré-requisitos

- Python 3.9 ou superior
- Docker e Docker Compose
- Conta OpenAI API (ou modelo local compatível)
- PostgreSQL com extensão pgvector

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/RomecyJr/Repo_Romecy.git
cd rag-helpdesk-assistant
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
# Edite .env com suas credenciais
```

3. Inicie os containers:
```bash
docker-compose up -d
```

4. Instale as dependências Python:
```bash
pip install -r requirements.txt
```

5. Inicialize o banco de dados:
```bash
python scripts/init_db.py
```

6. Carregue a base de conhecimento:
```bash
python scripts/load_knowledge_base.py --path ./data/docs
```

### Execução

#### Modo Desenvolvimento
```bash
# Backend
uvicorn app.main:app --reload --port 8000

# Frontend
cd frontend
npm install
npm run dev
```

#### Modo Produção
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 📖 Uso

### Interface Web

Acesse `http://localhost:3000` e comece a fazer perguntas ao assistente.

![Screenshot da Interface](docs/screenshots/interface-principal.png)
*Figura 1: Interface principal do assistente*

### API REST

#### Exemplo: Consultar assistente

```bash
curl -X POST "http://localhost:8000/api/v1/query" \
  -H "Content-Type: application/json" \
  -d '{
    "question": "Como resetar senha do usuário?",
    "ticket_id": "HD-12345"
  }'
```

**Resposta:**
```json
{
  "answer": "Para resetar a senha do usuário, siga os passos...",
  "confidence": 0.95,
  "sources": [
    {
      "document": "manual-usuarios.pdf",
      "page": 42,
      "relevance": 0.89
    }
  ],
  "ticket_id": "HD-12345"
}
```

### Exemplo Python

```python
import requests

def consultar_assistente(pergunta):
    response = requests.post(
        "http://localhost:8000/api/v1/query",
        json={"question": pergunta}
    )
    return response.json()

# Uso
resultado = consultar_assistente("Como configurar VPN corporativa?")
print(f"Resposta: {resultado['answer']}")
print(f"Confiança: {resultado['confidence']*100}%")
```

## 🧪 Testes

```bash
# Executar todos os testes
pytest

# Testes com cobertura
pytest --cov=app --cov-report=html

# Testes de integração
pytest tests/integration/
```

![Cobertura de Testes](docs/screenshots/test-coverage.png)
*Figura 2: Relatório de cobertura de testes (>85%)*

## 📊 Métricas e Monitoramento

O sistema expõe métricas Prometheus em `/metrics`:

- `helpdesk_queries_total` - Total de consultas
- `helpdesk_query_duration_seconds` - Tempo de resposta
- `helpdesk_confidence_score` - Score de confiança médio

![Dashboard Grafana](docs/screenshots/grafana-dashboard.png)
*Figura 3: Dashboard de monitoramento no Grafana*

## 🔧 Configuração Avançada

### Variáveis de Ambiente

```env
# API Keys
OPENAI_API_KEY=sk-...

# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/helpdesk
VECTOR_DIMENSION=1536

# LLM Config
LLM_MODEL=gpt-4
LLM_TEMPERATURE=0.3
MAX_TOKENS=500

# RAG Config
CHUNK_SIZE=512
CHUNK_OVERLAP=50
TOP_K_RESULTS=5
```

### Personalização do Prompt

Edite `config/prompts.yaml` para customizar o comportamento do assistente:

```yaml
system_prompt: |
  Você é um assistente especializado em suporte técnico.
  Forneça respostas claras e baseadas na documentação fornecida.
  Sempre cite as fontes das informações.
```

## 📦 Estrutura do Projeto

```
rag-helpdesk-assistant/
├── app/
│   ├── api/              # Endpoints da API
│   ├── core/             # Configurações core
│   ├── models/           # Modelos de dados
│   ├── services/         # Lógica de negócio
│   │   ├── embedding.py  # Geração de embeddings
│   │   ├── llm.py        # Interface LLM
│   │   └── rag.py        # Pipeline RAG
│   └── main.py           # Entry point
├── data/
│   └── docs/             # Base de conhecimento
├── frontend/             # Interface React
├── tests/                # Testes automatizados
├── docker-compose.yml
├── requirements.txt
└── README.md
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

### Padrões de Código

- Seguimos PEP 8 para Python
- Use type hints
- Escreva testes para novas funcionalidades
- Documente funções complexas

## 📝 Roadmap

- [ ] Suporte a modelos locais (Llama 2, Mistral)
- [ ] Interface de chat em tempo real
- [ ] Análise de sentimento nos tickets
- [ ] Auto-categorização de tickets
- [ ] Integração com Slack/Teams
- [ ] Modo offline com cache

## 🐛 Problemas Conhecidos

- A primeira consulta pode ser lenta devido ao carregamento do modelo
- Limitação de 100 requisições/minuto na API gratuita da OpenAI

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Autores

- **RomecyJr** - *Desenvolvimento inicial* - [GitHub](https://github.com/RomecyJr)

## 🙏 Agradecimentos

- OpenAI pela API GPT
- Comunidade LangChain
- Contribuidores do projeto pgvector

## 📞 Suporte

Para suporte, abra uma issue no GitHub ou entre em contato através do email: suporte@exemplo.com

---

⭐ Se este projeto foi útil, considere dar uma estrela!

**Última atualização:** Outubro 2025
