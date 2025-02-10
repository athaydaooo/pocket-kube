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

# Verifica se o parâmetro is_worker foi passado
IS_WORKER=false
if [ "${1:-}" == "--worker" ]; then
  echo "Instalando o K3s como worker..."
  IS_WORKER=true
fi

echo "Instalando K3s..."
if [ "$IS_WORKER" = true ]; then
  if [ -z "${K3S_URL:-}" ] || [ -z "${K3S_TOKEN:-}" ]; then
    echo "Erro: As variáveis K3S_URL e K3S_TOKEN devem estar definidas para instalar como worker." >&2
    exit 1
  fi
  if ! curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -s - --write-kubeconfig-mode 644; then
    echo "Erro ao instalar o K3s como worker. Verifique sua conexão com a internet e tente novamente." >&2
    exit 1
  fi
else
  if ! curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644; then
    echo "Erro ao instalar o K3s. Verifique sua conexão com a internet e tente novamente." >&2
    exit 1
  fi
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
