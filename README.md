# Pocket-Kube

Este repositório contém scripts e manifestos para instalar e configurar um ambiente Kubernetes utilizando **K3s**, **ArgoCD**, **Nginx** e **MetalLB**. Os scripts foram desenvolvidos seguindo boas práticas para facilitar a identificação e resolução de erros comuns.

## 📌 Requisitos

- **Sistema Operacional:** Linux (Ubuntu, Debian, etc.)
- **Permissão:** Usuário com privilégios de root ou sudo
- **Programas Necessários:**
  - `curl`
  - `kubectl`
  - `helm` (opcional, caso precise instalar aplicativos adicionais)
- **Conexão com a Internet**

## 📂 Estrutura do Repositório

```
k3s-argocd-setup/
├── apps/            # Arquivos YAML para deploy via ArgoCD
│   ├── argocd/
│       ├── Application.yaml
│   ├── ingress-nginx/
│       ├── Application.yaml
│   ├── metallb/
│       ├── Application.yaml
│       ├── IPAddressPool.yaml
├── scripts/              # Scripts de instalação e configuração
│   ├── install_k3s.sh
│   ├── install_argocd.sh
│   ├── deploy_apps.sh
│   ├── purge_k3s.sh      # Script para desinstalar completamente o K3s
└── install.sh
└── README.md             # Documentação do projeto
```

## 🚀 Instalação Completa

O primeiro passo é definir um bloco de IPs privados e acessiveis pela maquina em apps/metallb/IPAddressPool.yaml.

Esses IPs serão atribuidos às suas aplicações pelo nginx

```bash
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  labels:
    argocd.argoproj.io/instance: metallb
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
    - 172.29.223.254/32 # Altere o bloco de ip para um acessivel na sua maquina
```

Agora defina o dominio do ArgoCD em seu arquivo de ingress em apps/argocd/ingress.yaml

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
    - host: devops.pocket-kube.com #Altere para o dominio configurado em sua maquina
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 443

```

Para instalar todo o ambiente (K3s, ArgoCD, Nginx e MetalLB), basta executar:

```bash
chmod +x install.sh
./install.sh
```

Este script executa os seguintes passos:

1. **Instala o K3s** (Kubernetes leve e otimizado para edge computing)
2. **Instala o ArgoCD** (plataforma GitOps para gerenciamento de aplicações Kubernetes)
3. **Implanta aplicações via ArgoCD** (Nginx e MetalLB)

## 📜 Scripts Individuais

Caso queira executar cada etapa separadamente, utilize os seguintes comandos:

### 🖥️ Instalar K3s

```bash
chmod +x scripts/install_k3s.sh
./scripts/install_k3s.sh
```

### 📦 Instalar ArgoCD

```bash
chmod +x scripts/install_argocd.sh
./scripts/install_argocd.sh
```

### 📡 Implantar Aplicações (Nginx e MetalLB)

```bash
chmod +x scripts/deploy_apps.sh
./scripts/deploy_apps.sh
```

### 🗑️ Desinstalar K3s

```bash
chmod +x scripts/purge_k3s.sh
./scripts/purge_k3s.sh
```

## 📌 Acesso ao ArgoCD

Após a instalação, você pode acessar a interface do ArgoCD:

1. Obtenha a senha do usuário `admin`:

   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

2. Execute o comando de port-forward para acessar o painel web do ArgoCD:

   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

3. Acesse o painel web do ArgoCD:
   - URL: `https://localhost:8080`

## 🔧 Personalização

Se precisar alterar configurações, edite os arquivos dentro da pasta `apps/`.

## 🤝 Contribuição

Sinta-se à vontade para abrir **issues** ou enviar **pull requests** para melhorias neste projeto!

## 📜 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

💡 **Desenvolvido por [Lucas Athayde](https://github.com/LucasAthayde)** 🚀
