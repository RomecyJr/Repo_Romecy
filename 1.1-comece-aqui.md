# 🚀 GUIA RÁPIDO DE TESTES - Começando Agora

## ✅ O que você já tem pronto

- ✅ Python 3.14 instalado
- ✅ Git configurado
- ✅ Repositório com 5 projetos criados

---

## 🎯 TESTE #1 - Zabbix Discovery (2 minutos)

### O mais simples! Apenas 1 comando

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\zabbix-grafana-starter
python lld/disks_discovery.py
```

### ✅ Resultado esperado

```json
{"data": [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]}
```

**✨ Parabéns! Você testou seu primeiro projeto!**

---

## 🎯 TESTE #2 - Microservice Flask (5 minutos)

### Passo 1: Abra o PowerShell e execute

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice
```

### Passo 2: Rode o script de teste automático

```powershell
.\teste.ps1
```

**OU faça manualmente:**

```powershell
# Inicie o servidor
.\.venv\Scripts\python.exe -m flask --app src.app run
```

### Passo 3: Abra seu navegador e acesse

- 🌐 <http://localhost:5000/health>
- 🌐 <http://localhost:5000/>

### ✅ Você deve ver

- Na página `/health`: `{"status":"ok"}`
- Na página raiz `/`: `{"message":"hello from microservice"}`

### Para parar

Pressione `Ctrl+C` no terminal

---

## 🎯 TESTE #3 - RAG Helpdesk Assistant (10 minutos)

### Passo 1: Instalar dependências

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

⏳ **Isso vai demorar uns 5 minutos (baixa muitas bibliotecas de IA)**

### Passo 2: Iniciar o servidor

```powershell
uvicorn app.main:app --reload
```

### Passo 3: Testar no navegador

Abra: **<http://localhost:8000/docs>**

Você verá uma interface interativa linda! 🎨

### Passo 4: Testar a IA

Na página `/docs`:

1. Clique em **POST /ask**
2. Clique em **Try it out**
3. Cole este JSON:

```json
{
  "question": "Qual o SLA de P1?"
}
```

4. Clique em **Execute**

✨ A IA vai responder baseada na base de conhecimento!

---

## 🎯 TESTE #4 - ITSM Metrics Exporter (3 minutos)

### Passo 1: Instalar e rodar

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\itsm-metrics-exporter
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python exporter.py
```

### Passo 2: Ver as métricas

Abra: **<http://localhost:9108/metrics>**

### ✅ Você verá métricas como

```
itsm_open_tickets{source="jira",priority="P1"} 3.0
itsm_mttr_hours{source="jira"} 4.5
```

Essas métricas mudam a cada 15 segundos! 📊

---

## 🎯 TESTE #5 - Ansible (1 minuto - só validação)

### Verificar sintaxe dos playbooks

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\ansible-infra-baseline
pip install ansible
ansible-playbook --syntax-check playbooks/linux_hardening.yml
```

### ✅ Se aparecer

```
playbook: playbooks/linux_hardening.yml
```

**Significa que o playbook está correto!** ✨

---

## 🐳 BONUS: Teste com Docker

Se você tem Docker Desktop instalado:

### Microservice com Docker

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice
docker build -t demo-ms:local .
docker run -p 8080:5000 demo-ms:local
```

Acesse: <http://localhost:8080/health>

### RAG com Docker

```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant
docker build -t rag-helpdesk:local .
docker run -p 8000:8000 rag-helpdesk:local
```

Acesse: <http://localhost:8000/docs>

---

## 🎬 DEMO RÁPIDO - Mostre para alguém

### Sequência para impressionar em 2 minutos

1. **Zabbix Discovery:**

   ```powershell
   cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\zabbix-grafana-starter
   python lld/disks_discovery.py
   ```

   *"Este script descobre discos automaticamente para monitoramento"*

2. **Microservice:**

   ```powershell
   cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\docker-k8s-microservice
   .\.venv\Scripts\python.exe -m flask --app src.app run
   ```

   Abra navegador: <http://localhost:5000/health>
   *"Um microservice pronto para Kubernetes"*

3. **RAG Helpdesk:**
   Se já instalou, rode:

   ```powershell
   cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy\rag-helpdesk-assistant
   uvicorn app.main:app
   ```

   Abra: <http://localhost:8000/docs>
   *"Assistente de IA que responde dúvidas de suporte!"*

---

## 📱 Teste pelo Celular (na mesma rede WiFi)

1. Descubra seu IP:

   ```powershell
   ipconfig | findstr IPv4
   ```

2. Com o servidor rodando, acesse do celular:

   ```
   http://SEU_IP:5000/health
   http://SEU_IP:8000/docs
   ```

---

## 🎥 Grave um Vídeo

1. Abra o OBS Studio ou gravador de tela
2. Execute os testes
3. Mostre funcionando
4. Poste no LinkedIn com:

   ```
   🚀 Meu portfólio técnico:
   - RAG com IA para Helpdesk
   - Microservices com Docker/K8s
   - Automação Ansible
   - Métricas ITSM
   - Monitoramento Zabbix

   Código: github.com/RomecyJr/Repo_Romecy
   ```

---

## 🐛 Problemas? Soluções Rápidas

### "python: command not found"

```powershell
python --version
# Se não funcionar, reinstale Python
```

### "pip install demora muito"

```powershell
# Use um espelho mais rápido:
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### "Porta já está em uso"

```powershell
# Encontre o processo:
netstat -ano | findstr :5000
# Mate o processo (substitua PID):
taskkill /PID XXXX /F
```

### "Docker não funciona"

```powershell
# Inicie o Docker Desktop
# Ou teste sem Docker primeiro
```

---

## ✅ Checklist de Testes

Marque conforme testa:

- [ ] Zabbix Discovery (lld/disks_discovery.py)
- [ ] Microservice Flask (/health endpoint)
- [ ] RAG Helpdesk (/docs interface)
- [ ] ITSM Exporter (/metrics)
- [ ] Ansible (syntax-check)
- [ ] Docker build (microservice)
- [ ] Docker build (RAG)
- [ ] Navegador mobile
- [ ] Screenshots tirados
- [ ] LinkedIn atualizado

---

## 🎓 Próximos Níveis

### Nível 1 ✅ (você está aqui)

- Testar localmente
- Ver funcionando

### Nível 2

- Customizar o código
- Adicionar features
- Melhorar documentação

### Nível 3

- Deploy em cloud
- CI/CD automatizado
- Monitoramento real

---

## 💡 Dica Pro

**Grave um GIF animado** mostrando os testes e coloque no README!

Use: <https://www.screentogif.com/>

---

**Comece pelo TESTE #1 (Zabbix) - é o mais rápido! 🚀**

Qualquer dúvida, consulte o `GUIA_DE_TESTES.md` completo.
