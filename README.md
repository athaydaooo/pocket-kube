# Pocket-Kuve

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
└── install.sh
└── README.md             # Documentação do projeto
```

## 🚀 Instalação Completa

Para instalar todo o ambiente (K3s, ArgoCD, Nginx e MetalLB), basta executar:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
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

## 📌 Acesso ao ArgoCD

Após a instalação, você pode acessar a interface do ArgoCD:

1. Obtenha a senha do usuário `admin`:

   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

2. Acesse o painel web do ArgoCD:
   - URL: `https://<IP_DO_CLUSTER>:<PORTA_NODEPORT>`

## 🔧 Personalização

Se precisar alterar configurações, edite os arquivos dentro da pasta `apps/`.

## 🤝 Contribuição

Sinta-se à vontade para abrir **issues** ou enviar **pull requests** para melhorias neste projeto!

## 📜 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

💡 **Desenvolvido por [Lucas Athayde](https://github.com/LucasAthayde)** 🚀
