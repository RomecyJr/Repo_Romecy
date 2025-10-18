#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Instalando hooks do pre-commit..."
if command -v pre-commit >/dev/null 2>&1; then
  pre-commit install
else
  echo "Instale 'pre-commit' (pipx install pre-commit ou pip install pre-commit)." >&2
fi

echo "✅ Pronto. Consulte README.md para próximos passos."
