# Padrões do Repositório

- **Nomes**: `kebab-case`, sem acentos (ex.: `guia-de-testes.md`).
- **Texto**: português no conteúdo; inglês aceito em código, APIs e nomes de tecnologia.
- **Pastas**:
  - `projetos/<nome>` → código, `README.md`, `tests/`, `Dockerfile`, `compose.yml`.
  - `docs/` → documentação geral.
  - `scripts/` → utilidades de setup.
- **Formatação**: siga `.editorconfig` + "Format on Save".
- **Qualidade**: `pre-commit` roda lints (Markdown e ortografia).
