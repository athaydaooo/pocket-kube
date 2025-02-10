#!/bin/bash
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

echo "🚀 Iniciando o setup completo do ambiente K3s + ArgoCD + Nginx + MetalLB como Worker..."

SCRIPTS_DIR="./scripts"
for script in install_k3s.sh install_argocd.sh deploy_apps.sh; do
  if [ ! -f "$SCRIPTS_DIR/$script" ]; then
    echo "Erro: Script '$SCRIPTS_DIR/$script' não encontrado." >&2
    exit 1
  fi
done

echo "Executando o script de instalação do K3s como Worker..."
chmod +x scripts/install_k3s.sh
./scripts/install_k3s.sh --worker || { echo "Erro: O script install_k3s.sh falhou." >&2; exit 1; }

echo "🎉 Setup completo! O ambiente está pronto para uso como Worker."
