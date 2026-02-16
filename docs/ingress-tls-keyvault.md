# Ingress + HTTPS on AKS (NGINX + cert-manager + Azure Key Vault)

This guide shows an enterprise-friendly approach for TLS on AKS using:
- NGINX Ingress Controller
- cert-manager
- Azure Key Vault as certificate source (via Secrets Store CSI Driver) OR ACME/Let's Encrypt

> There are multiple valid approaches. Choose ONE depending on your org policies.

---

## Option A (Common): cert-manager + Let's Encrypt (ACME)

### 1) Install NGINX ingress controller
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx   -n ingress-nginx --create-namespace
```

### 2) Install cert-manager
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager   -n cert-manager --create-namespace   --set crds.enabled=true
```

### 3) Create ClusterIssuer (Let's Encrypt)
Edit email + environment (staging vs prod):
```bash
kubectl apply -f k8s/cert-manager/clusterissuer-letsencrypt-staging.yaml
# or:
kubectl apply -f k8s/cert-manager/clusterissuer-letsencrypt-prod.yaml
```

### 4) Enable ingress + TLS in Helm values
```bash
helm upgrade --install demo-api ./helm/demo-api -n demo --create-namespace   --set ingress.enabled=true   --set ingress.className=nginx   --set ingress.hostname=demo.example.com   --set ingress.tls.enabled=true   --set ingress.tls.secretName=demo-api-tls   --set ingress.tls.clusterIssuer=letsencrypt-staging
```

---

## Option B (Enterprise): Key Vault + Secrets Store CSI Driver

This option is used when your organization requires certificates managed centrally in Azure Key Vault.

### 1) Install Secrets Store CSI driver + Azure provider
```bash
helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
helm repo update

helm upgrade --install csi-secrets-store csi-secrets-store-provider-azure/csi-secrets-store-provider-azure   -n kube-system
```

### 2) Create Key Vault and store certificate
Create a Key Vault and upload a certificate (PFX) using Azure portal or CLI.

### 3) Enable workload identity (recommended) for AKS
AKS Workload Identity allows pods to access Key Vault without secrets.

### 4) Deploy SecretProviderClass
Use `k8s/keyvault/secretproviderclass.yaml` and fill in:
- tenantId
- keyvaultName
- certificate objectName

Then deploy:
```bash
kubectl apply -n demo -f k8s/keyvault/secretproviderclass.yaml
```

### 5) Mount certificate secret and reference in ingress
Use `secretObjects` in SecretProviderClass to materialize a Kubernetes TLS secret.
Then set in Helm:
- `ingress.tls.secretName=demo-api-tls`

---

## Notes
- For a portfolio project, Option A is simplest and widely recognized.
- For enterprise interviews, Option B demonstrates governance and security best practices.
