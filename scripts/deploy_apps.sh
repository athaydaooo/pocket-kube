#!/bin/bash
set -euo pipefail
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

check_command() {
  if ! command -v kubectl >/dev/null 2>&1; then
    echo "Erro: 'kubectl' não está instalado. Por favor, instale-o e tente novamente." >&2
    exit 1
  fi
}

check_command kubectl

echo "Criando namespaces 'ingress-nginx' e 'metallb-system'..."
kubectl create namespace ingress-nginx 2>/dev/null || echo "Namespace 'ingress-nginx' já existe, continuando..."
kubectl create namespace metallb-system 2>/dev/null || echo "Namespace 'metallb-system' já existe, continuando..."

echo "Aplicando a aplicação Nginx no ArgoCD..."
if ! kubectl apply -f ../ingress-nginx/Application.yaml; then
  echo "Erro ao aplicar o manifesto do Nginx no ArgoCD." >&2
  exit 1
fi

echo "Aplicando a aplicação MetalLB no ArgoCD..."
if ! kubectl apply -f ../metallb/Application.yaml; then
  echo "Erro ao aplicar o manifesto do MetalLB no ArgoCD." >&2
  exit 1
fi

echo "Configurando o MetalLB..."
if ! kubectl apply -f ../metallb/IPAdressPool.yaml; then
  echo "Erro ao aplicar a configuração do MetalLB. Verifique o manifesto." >&2
  exit 1
fi

echo "Deploy das aplicações concluído com sucesso! 🎉"
