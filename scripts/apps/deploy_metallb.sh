echo "Criando namespace 'metallb-system'..."

kubectl create namespace metallb-system 2>/dev/null || echo "Namespace 'metallb-system' já existe, continuando..."

echo "Aplicando CRDs do MetalLB..."
if ! kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/crd/bases/metallb.io_ipaddresspools.yaml; then
    echo "Erro ao aplicar o CRD 'metallb.io_ipaddresspools'." >&2
    exit 1
fi

if ! kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/crd/bases/metallb.io_l2advertisements.yaml; then
    echo "Erro ao aplicar o CRD 'metallb.io_l2advertisements'." >&2
    exit 1
fi

echo "Aplicando a aplicação MetalLB no ArgoCD..."
if ! kubectl apply -f "apps/metallb/Application.yaml"; then
  echo "Erro ao aplicar o manifesto do MetalLB no ArgoCD." >&2
  exit 1
fi

sleep 30

echo "Configurando o MetalLB IPAddressPool..."
if ! kubectl apply -f "apps/metallb/IPAddressPool.yaml"; then
  echo "Erro ao aplicar a configuração do MetalLB. Verifique o manifesto." >&2
  exit 1
fi

echo "Configurando o MetalLB L2Advertisement..."
if ! kubectl apply -f "apps/metallb/L2Advertisement.yaml"; then
  echo "Erro ao aplicar a configuração do MetalLB. Verifique o manifesto." >&2
  exit 1
fi