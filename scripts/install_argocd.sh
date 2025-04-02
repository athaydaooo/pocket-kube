#!/bin/bash
set -euo pipefail
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Erro: '$1' não está instalado. Por favor, instale-o e tente novamente." >&2
    exit 1
  fi
}

# Verifica se os comandos essenciais estão disponíveis
check_command curl
check_command kubectl

echo "Instalando ArgoCD..."
if ! kubectl create namespace argocd 2>/dev/null; then
  echo "Aviso: O namespace 'argocd' já existe. Prosseguindo com a instalação..."
fi

if ! kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml; then
  echo "Erro ao aplicar o manifesto do ArgoCD. Verifique sua conexão com a internet." >&2
  exit 1
fi

echo "Baixando a CLI do ArgoCD..."
if ! sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64; then
  echo "Erro ao baixar a CLI do ArgoCD." >&2
  exit 1
fi
sudo chmod +x /usr/local/bin/argocd

echo "Aguardando o ArgoCD subir (pode levar alguns instantes)..."
sleep 30

echo "Configurando o ArgoCD ingress..."
if ! kubectl apply -f "apps/argocd/ingress.yaml"; then
  echo "Erro ao aplicar a configuração de Ingress Argocd. Verifique o manifesto." >&2
  exit 1
fi

echo "Instalação do ArgoCD concluída! ✅"