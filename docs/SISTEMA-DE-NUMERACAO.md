# 📋 Sistema de Numeração da Documentação

## 🎯 Como Funciona

Este repositório usa um **sistema de numeração hierárquica** para organizar toda a documentação.

### Estrutura de Numeração

```
[SEÇÃO].[SUBSEÇÃO]-nome-descritivo.md
    ↓        ↓              ↓
 Categoria  Ordem    Nome legível
```

---

## 📚 Categorias

### **0.x - Índices e Navegação**
- `0.0-INDICE.md` → Índice mestre com todos os documentos

### **1.x - Documentação Principal**
- `1.0-README.md` → Apresentação do portfólio
- `1.1-comece-aqui.md` → Guia de início rápido
- `1.2-explicacao-projetos.md` → Visão geral dos projetos

### **2.x - Guias e Tutoriais**
- `2.0-guia-de-testes.md` → Como executar testes
- `2.1-instrucoes-git.md` → Workflow Git
- `2.2-readme-testes.md` → Testes detalhados

### **3.x - Projetos** (dentro de cada pasta)
- `3.1-README.md` → Ansible Infrastructure
- `3.2-README.md` → Docker & Kubernetes
- `3.3-README.md` → ITSM Metrics
- `3.4-README.md` → RAG Helpdesk
- `3.5-README.md` → Zabbix Grafana

### **4.x - Arquitetura** (futuro)
- Documentação técnica avançada
- Diagramas de arquitetura

### **5.x - APIs e Referências** (futuro)
- Documentação de APIs
- Referências técnicas

---

## 🗺️ Mapa Visual

```
0.0-INDICE.md  ← COMECE AQUI!
│
├─ 1.0-README.md ───────┐
├─ 1.1-comece-aqui.md   │ Leia primeiro
├─ 1.2-explicacao...md ─┘
│
├─ 2.0-guia-de-testes.md ──┐
├─ 2.1-instrucoes-git.md   │ Guias práticos
├─ 2.2-readme-testes.md ───┘
│
└─ 3.x-README.md ─────────── Projetos individuais
```

---

## ✅ Vantagens do Sistema

| Antes | Depois |
|-------|--------|
| ❌ `COMECE_AQUI_TESTES.MD` | ✅ `1.1-comece-aqui.md` |
| ❌ `EXPLICACAO_PROJETOS.MD` | ✅ `1.2-explicacao-projetos.md` |
| ❌ Caixa alta confusa | ✅ kebab-case legível |
| ❌ Ordem aleatória | ✅ Numeração lógica |

### Benefícios:
- 🎯 **Ordem clara** → Arquivos sempre ordenados
- 🔍 **Fácil navegação** → Sabe exatamente onde procurar
- 📖 **Hierarquia visual** → Entende a estrutura rapidamente
- 🌐 **URLs amigáveis** → Links funcionam melhor no GitHub

---

## 🚀 Como Navegar

### Método 1: Pelo Índice
1. Abra `0.0-INDICE.md`
2. Clique no link desejado
3. Navegue pela hierarquia

### Método 2: Por Número
Precisa de algo? Lembre do número:
- **1.x** = Informação geral
- **2.x** = Como fazer algo
- **3.x** = Projeto específico

### Método 3: Busca
```bash
# Procurar por tópico
ls *git*.md        # → 2.1-instrucoes-git.md
ls 1.*.md          # → Todos os docs principais
ls 3.*.md          # → Todos os READMEs de projetos
```

---

## 📝 Convenções de Nomenclatura

### ✅ Fazer:
- Usar números sequenciais: `1.0`, `1.1`, `1.2`
- Usar kebab-case: `comece-aqui`, `guia-de-testes`
- Ser descritivo: `explicacao-projetos` não `explicacao`
- Lowercase: `readme.md` não `README.MD`

### ❌ Evitar:
- CAIXA ALTA: ~~`COMECE_AQUI.MD`~~
- Espaços: ~~`Comece Aqui.md`~~
- Caracteres especiais: ~~`guia_de_testes.md`~~
- Nomes vagos: ~~`docs.md`~~

---

## 🔄 Expansão Futura

Quando adicionar novos documentos:

```
4.0-arquitetura-geral.md
4.1-arquitetura-ansible.md
4.2-arquitetura-k8s.md

5.0-api-reference.md
5.1-api-itsm-exporter.md
5.2-api-rag-assistant.md
```

---

## 🎨 Exemplo Prático

**Cenário:** Novo colaborador no projeto

```
Dia 1: 0.0-INDICE.md → Visão geral
       1.0-README.md → Entender o portfólio
       1.1-comece-aqui.md → Setup inicial

Dia 2: 2.0-guia-de-testes.md → Rodar testes
       2.1-instrucoes-git.md → Contribuir

Dia 3: 3.4-README.md → Trabalhar no RAG Assistant
```

**Resultado:** Onboarding organizado e eficiente! 🎉

---

## 📞 Dúvidas?

Esse sistema foi criado para facilitar sua vida!
Se algo não está claro, abra um issue ou consulte `0.0-INDICE.md`

**Happy coding! 🚀**
