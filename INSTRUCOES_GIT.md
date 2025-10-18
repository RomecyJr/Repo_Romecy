# Instruções para Configurar o Git

## Problema Identificado
O comando `git` não é reconhecido porque o Git não está instalado no sistema.

## Solução

### Passo 1: Instalar o Git
1. Acesse: https://git-scm.com/download/win
2. Baixe o instalador mais recente (64-bit)
3. Execute o instalador com estas configurações:
   - ✓ "Git from the command line and also from 3rd-party software"
   - ✓ "Use Windows' default console window"
   - ✓ Mantenha as demais opções padrão

### Passo 2: Verificar Instalação
Após instalar, **feche e reabra** o VS Code ou PowerShell, então teste:
```powershell
git --version
```

Deve retornar algo como: `git version 2.43.0.windows.1`

### Passo 3: Configurar Git (Primeira Vez)
```powershell
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"
```

### Passo 4: Inicializar o Repositório (se necessário)
```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy
git init
git remote add origin https://github.com/RomecyJr/Repo_Romecy.git
```

### Passo 5: Executar o Script de Setup
Depois que o Git estiver funcionando:
```powershell
cd c:\Users\admin\GITHUB_ROMER\Repo_Romecy
bash vscode_llm_setup.sh
```

## Alternativa: GitHub Desktop
Se preferir uma interface gráfica:
1. Instale o GitHub Desktop: https://desktop.github.com/
2. Clone o repositório pela interface
3. O Git CLI será instalado automaticamente

## Verificando o PATH (Avançado)
Se o Git foi instalado mas ainda não funciona:
```powershell
$env:Path -split ';' | Select-String -Pattern 'git'
```

Se não aparecer nada, adicione manualmente:
- Caminho típico: `C:\Program Files\Git\cmd`
- Painel de Controle → Sistema → Configurações avançadas do sistema → Variáveis de Ambiente

## Após Configurar o Git
Execute o script que criará toda a estrutura do portfólio:
```bash
bash vscode_llm_setup.sh
```

Isso vai:
- ✓ Criar as 5 pastas de projetos com código funcional
- ✓ Adicionar READMEs, Dockerfiles, workflows de CI
- ✓ Configurar .gitignore e LICENSE
- ✓ Atualizar README principal
- ✓ Fazer commit e push automático
