variable "subscription_id" { type = string }
variable "tenant_id"       { type = string }

variable "location" { type = string default = "eastus" }
variable "resource_group_name" { type = string default = "aks-enterprise-rg" }
variable "aks_cluster_name" { type = string default = "aks-enterprise" }

variable "acr_name" {
  type        = string
  description = "ACR name (globally unique, 5-50 alphanumeric)"
  default     = "acrdemoenterprise12345"
}

variable "kubernetes_version" { type = string default = "1.29.7" }
variable "node_vm_size" { type = string default = "Standard_D4s_v5" }
variable "node_count" { type = number default = 2 }

variable "tags" {
  type = map(string)
  default = {
    Project   = "azure-aks-enterprise-platform"
    ManagedBy = "Terraform"
  }
}
