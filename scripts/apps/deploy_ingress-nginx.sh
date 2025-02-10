echo "Criando namespace 'ingress-nginx'..."

kubectl create namespace ingress-nginx 2>/dev/null || echo "Namespace 'ingress-nginx' já existe, continuando..."

echo "Aplicando a aplicação Nginx no ArgoCD..."
if ! kubectl apply -f "apps/ingress-nginx/Application.yaml"; then
  echo "Erro ao aplicar o manifesto do Nginx no ArgoCD." >&2
  exit 1
fi
