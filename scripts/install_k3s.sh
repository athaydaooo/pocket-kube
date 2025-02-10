#!/bin/bash
set -euo pipefail
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

# Função para verificar se um comando está instalado
check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Erro: '$1' não está instalado. Por favor, instale-o e tente novamente." >&2
    exit 1
  fi
}

# Verifica se o curl está instalado
check_command curl

echo "Instalando K3s..."
if ! curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644; then
  echo "Erro ao instalar o K3s. Verifique sua conexão com a internet e tente novamente." >&2
  exit 1
fi

echo "Exportando variável KUBECONFIG..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

if [ ! -f "$KUBECONFIG" ]; then
  echo "Erro: Arquivo KUBECONFIG não encontrado em $KUBECONFIG" >&2
  exit 1
fi

echo "Aguardando o K3s iniciar..."
sleep 10

echo "Instalação do K3s concluída! 🚀"
