# Configuração de Aprovação Automática do GitHub Copilot

## 📋 Objetivo

Este documento explica como configurar o VS Code para aprovar **automaticamente TODOS os comandos** executados pelo GitHub Copilot no terminal, sem necessidade de confirmação manual.

## ⚙️ Configurações Aplicadas

### 1. **Settings do Workspace** (`.vscode/settings.json`)

```jsonc
{
  // Aprova TODOS os comandos do terminal automaticamente
  "github.copilot.chat.terminalCmdApproval": {
    "/.*/": true  // Regex que captura QUALQUER comando
  },

  // Habilita execução de comandos pelo Copilot
  "github.copilot.chat.runCommand.enabled": true,

  // Desabilita confirmações de segurança de workspace
  "security.workspace.trust.enabled": false,

  // Permite execução automática de tarefas
  "task.autoDetect": "on",
  "task.allowAutomaticTasks": "on"
}
```

### 2. **Settings Globais do Usuário** (`%APPDATA%\Code\User\settings.json`)

As mesmas configurações são aplicadas globalmente para todos os workspaces.

## 🚀 Como Aplicar

### Opção 1: Script Automatizado (Recomendado)

Execute o script PowerShell:

```powershell
.\scripts\powershell\config_aprovacao_automatica.ps1
```

### Opção 2: Manual

1. Abra **Configurações** do VS Code (`Ctrl+,`)
2. Clique em **{}** (Open Settings JSON) no canto superior direito
3. Adicione as configurações acima
4. Salve o arquivo
5. **Recarregue o VS Code** (`Ctrl+Shift+P` → "Reload Window")

## ⚠️ Avisos Importantes

### Segurança

- ✅ **Esta configuração remove TODAS as proteções de aprovação de comandos**
- ⚠️ O Copilot poderá executar **QUALQUER comando** sem confirmação
- ⚠️ Comandos destrutivos (`rm -rf`, `git push --force`, etc.) serão executados automaticamente
- ⚠️ **Use apenas em ambientes de desenvolvimento/teste controlados**

### Comandos Aprovados Automaticamente

Com `"/.*/": true`, os seguintes tipos de comandos são aprovados SEM confirmação:

- ✅ `git` (push, pull, commit, reset, etc.)
- ✅ `npm` / `yarn` / `pip` (install, build, publish)
- ✅ `docker` (build, run, rm, rmi)
- ✅ `rm` / `del` (remover arquivos/diretórios)
- ✅ `powershell` / `bash` (scripts e comandos)
- ✅ `python` / `node` / `java` (execução de código)
- ✅ **Qualquer outro comando do sistema**

## 🔧 Configurações Adicionais

### Para aprovar apenas comandos específicos:

```jsonc
{
  "github.copilot.chat.terminalCmdApproval": {
    "git": true,                    // Aprova todos comandos git
    "npm run": true,                // Aprova npm run *
    "/^python\\b/": true,           // Aprova comandos que começam com 'python'
    "rm": false,                    // NEGA comandos rm (exige aprovação)
    "/\\.ps1/i": { "approve": false, "matchCommandLine": true }  // NEGA scripts .ps1
  }
}
```

### Regex úteis:

- `"/.*/": true` → Aprova **TUDO**
- `"/^git\\b/": true` → Aprova apenas comandos Git
- `"/^(npm|yarn)\\b/": true` → Aprova npm OU yarn
- `"rm": false` → **NEGA** comandos rm (exige confirmação)

## 📚 Referências

- [VS Code - GitHub Copilot Chat Settings](https://code.visualstudio.com/docs/copilot/copilot-chat)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)

## 🎯 Resultado Esperado

Após aplicar as configurações e recarregar o VS Code:

1. ✅ GitHub Copilot **não pedirá confirmação** para executar comandos
2. ✅ Comandos serão executados **imediatamente** após serem sugeridos
3. ✅ **Nenhuma popup** de aprovação aparecerá
4. ✅ Workflow fica **100% automático**

---

**Última atualização:** 18/10/2025
**Autor:** Romecy Veiga (com assistência do GitHub Copilot)
