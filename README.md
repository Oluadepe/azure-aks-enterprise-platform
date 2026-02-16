# Azure AKS Enterprise Platform  
**Terraform · Azure DevOps · AKS · ACR · Helm · Key Vault · Azure Monitor**

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform)
![Azure](https://img.shields.io/badge/Cloud-Azure-0078D4?logo=microsoftazure)
![Kubernetes](https://img.shields.io/badge/Platform-AKS-326CE5?logo=kubernetes)
![Helm](https://img.shields.io/badge/Deployment-Helm-0F1689?logo=helm)
![CI/CD](https://img.shields.io/badge/CI/CD-Azure%20DevOps-0078D7?logo=azuredevops)
![License](https://img.shields.io/badge/License-MIT-green)

**Version:** v1.1.0  
**Last Updated:** 2026-02-14  

---

# Platform Overview

This repository implements an **enterprise-grade Kubernetes platform on Microsoft Azure**, designed using Infrastructure as Code (Terraform) and automated CI/CD pipelines (Azure DevOps and GitHub Actions).

It demonstrates real-world DevOps and Platform Engineering practices for provisioning, deploying, and operating containerized applications securely and reliably on Azure Kubernetes Service (AKS).

This platform provides:

- Automated AKS cluster provisioning using Terraform  
- Secure container build and storage in Azure Container Registry (ACR)  
- Fully automated CI/CD pipelines using Azure DevOps and GitHub Actions  
- Kubernetes application deployment using Helm  
- HTTPS enablement using cert-manager and Azure Key Vault  
- Observability using Azure Monitor and Log Analytics  
- Multi-environment deployment support (dev / staging / prod)

This project reflects production-style cloud platform architecture used in enterprise environments.

---

# Architecture

![Architecture](docs/architecture.png)

---

# Deployment Workflow

```text
Developer Commit
      │
      ▼
CI Pipeline (Azure DevOps / GitHub Actions)
      │
      ├── Build Docker Image
      ├── Push Image to Azure Container Registry (ACR)
      │
      ▼
CD Pipeline
      │
      ├── Authenticate to Azure
      ├── Connect to AKS cluster
      ├── Deploy application using Helm
      │
      ▼
Azure Kubernetes Service (AKS)
      │
      ├── Kubernetes Deployment
      ├── Kubernetes Service
      ├── Optional Ingress with TLS
      │
      ▼
Application accessible to users
```

---

# Repository Structure

```text
azure-aks-enterprise-platform/
│
├── app/                          # Sample FastAPI application
│   ├── main.py
│   └── requirements.txt
│
├── terraform/                   # Infrastructure as Code (AKS, ACR, Networking)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── backend.tf.example
│   └── terraform.tfvars.example
│
├── helm/demo-api/               # Helm chart for application deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│
├── k8s/                         # Kubernetes platform components
│   ├── cert-manager/
│   └── keyvault/
│
├── pipelines/
│   └── azure-pipelines.yml     # Azure DevOps CI/CD pipeline
│
├── .github/workflows/
│   └── deploy.yml              # GitHub Actions CI/CD pipeline
│
├── docs/
│   ├── architecture.png
│   ├── ingress-tls-keyvault.md
│   └── monitoring-azure-monitor.md
│
├── Dockerfile
├── VERSION
├── LICENSE
└── README.md
```

---

# Infrastructure Provisioning (Terraform)

## Prerequisites

Install required tools:

- Terraform >= 1.6  
- Azure CLI  
- kubectl  
- Helm  
- Docker  

Login to Azure:

```bash
az login
az account show
```

---

## Step 1: Configure Terraform Backend

```bash
cp terraform/backend.tf.example terraform/backend.tf
```

Edit backend configuration.

---

## Step 2: Configure Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit values.

---

## Step 3: Deploy Infrastructure

```bash
terraform init
terraform apply -auto-approve
```

Provisions:

- Resource Group  
- AKS cluster  
- ACR registry  
- Log Analytics  

---

## Step 4: Connect to Cluster

```bash
az aks get-credentials \
  --resource-group <resource_group> \
  --name <aks_cluster_name> \
  --overwrite-existing

kubectl get nodes
```

---

# CI/CD Pipelines

This platform supports:

- Azure DevOps Pipelines
- GitHub Actions

Pipeline tasks:

- Build container image
- Push to ACR
- Deploy to AKS using Helm

---

# Deploy Application (Helm)

```bash
helm upgrade --install demo-api ./helm/demo-api \
  --namespace demo \
  --create-namespace
```

Verify:

```bash
kubectl get pods -n demo
kubectl get svc -n demo
```

Test:

```bash
kubectl port-forward svc/demo-api 8080:80 -n demo
curl http://localhost:8080/health
```

Expected:

```json
{"status":"ok"}
```

---

# HTTPS and TLS

Supports secure HTTPS using:

- cert-manager  
- Azure Key Vault  
- Kubernetes Ingress  

Example:

```bash
kubectl apply -f k8s/cert-manager/clusterissuer-letsencrypt-staging.yaml
```

---

# Monitoring

Enabled via Azure Monitor and Log Analytics.

See:

```
docs/monitoring-azure-monitor.md
```

---

# Security

Security best practices implemented:

- No secrets in Git
- Azure Key Vault integration
- Secure Terraform backend support
- Private container registry
- TLS encryption support

---

# Multi-Environment Deployment

Supports:

- dev
- staging
- prod

Configured via pipeline parameters.

---

# Local Development

```bash
docker build -t demo-api .
docker run -p 8080:80 demo-api

curl http://localhost:8080/health
```

---

# Versioning

Uses Semantic Versioning:

```
MAJOR.MINOR.PATCH
```

Example:

```
v1.1.0
```

---

# Cleanup

```bash
cd terraform
terraform destroy -auto-approve
```

---

# Author

Olusegun Mayungbe  
DevOps Engineer | Platform Engineer  

GitHub: https://github.com/Oluadepe  

---

# License

MIT License
