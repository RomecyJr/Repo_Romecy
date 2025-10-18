# Guia de Contribuição

Obrigado por contribuir! Este documento define como trabalhamos neste monorepo.

## Branches e Commits
- Use **Conventional Commits**: `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`.
- Crie branches curtas: `feat/rag-busca-faiss` ou `fix/exporter-cors`.

## Estilo e Qualidade
- **EditorConfig** define indentação e fim de linha.
- **Markdownlint** valida `.md`.
- **cspell** revisa ortografia pt-BR/EN.
- Rode localmente: `pre-commit run --all-files`.

## Estrutura
- Cada projeto fica em `projetos/<nome>` com `README.md`, `Dockerfile`, `compose.yml` (se houver) e `tests/`.
- Documentos gerais ficam em `docs/`.

## Pull Requests
1. Descreva claramente o objetivo.
2. Inclua passos de teste e prints (quando aplicável).
3. Mantenha PRs pequenos e focados.
