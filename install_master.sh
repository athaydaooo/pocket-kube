#!/bin/bash
trap 'echo "Erro na linha ${LINENO}: comando >> $BASH_COMMAND" >&2' ERR

echo "🚀 Iniciando o setup completo do ambiente K3s + ArgoCD + Nginx + MetalLB..."

SCRIPTS_DIR="./scripts"
for script in install_k3s.sh install_argocd.sh deploy_apps.sh; do
  if [ ! -f "$SCRIPTS_DIR/$script" ]; then
    echo "Erro: Script '$SCRIPTS_DIR/$script' não encontrado." >&2
    exit 1
  fi
done

echo "Executando o script de instalação do K3s..."
chmod +x scripts/install_k3s.sh
./scripts/install_k3s.sh || { echo "Erro: O script install_k3s.sh falhou." >&2; exit 1; }

echo "Executando o script de instalação do ArgoCD..."
chmod +x scripts/install_argocd.sh
./scripts/install_argocd.sh || { echo "Erro: O script install_argocd.sh falhou." >&2; exit 1; }

echo "Executando o script de deploy das aplicações..."
chmod +x scripts/deploy_apps.sh
./scripts/deploy_apps.sh || { echo "Erro: O script deploy_apps.sh falhou." >&2; exit 1; }

echo "🎉 Setup completo! O ambiente está pronto para uso."

echo "Acesse o ArgoCD através da seguinte senha:"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo
