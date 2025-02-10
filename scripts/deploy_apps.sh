#!/bin/bash
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

check_command() {
  if ! command -v kubectl >/dev/null 2>&1; then
    echo "Erro: 'kubectl' não está instalado. Por favor, instale-o e tente novamente." >&2
    exit 1
  fi
}

check_command kubectl


for script in scripts/apps/*.sh; do
  chmod +x  "$script"
  if [ -x "$script" ]; then
    "$script"
    if [ $? -eq 1 ]; then
      echo "Erro: Não foi possivel instalar $script." >&2
    fi
  else
    echo "Aviso: O script $script não é executável." >&2
  fi
done


echo "Deploy das aplicações concluído com sucesso! 🎉"
