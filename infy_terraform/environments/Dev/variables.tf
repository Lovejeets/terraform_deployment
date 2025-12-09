variable "env" {
  description = "The name of the environment"
  type        = string
  default     = "preprod"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "CentralIndia"
}

variable "enable_storage_account" {
  description = "Enable or disable Storage Account module"
  type        = bool
  default     = false
}
variable "enable_function_app" {
  description = "Enable or disable Function App module"
  type        = bool
  default     = false
}
variable "enable_aks" {
  description = "Enable or disable AKS module"
  type        = bool
  default     = false
}
variable "enable_kv" {
  description = "Enable or disable Key Vault module"
  type        = bool
  default     = false
}
variable "enable_postgresql_flex" {
  description = "Enable or disable PostgreSQL Flexible Server module"
  type        = bool
  default     = false
}
variable "enable_apim" {
  description = "Enable or disable API Management module"
  type        = bool
  default     = false
}
variable "enable_redis_cache" {
  description = "Enable or disable Redis Cache module"
  type        = bool
  default     = false
}
variable "enable_sqlmi" {
  description = "Enable or disable SQL Managed Instance module"
  type        = bool
  default     = false
}
variable "enable_virtual_networks" {
  type    = bool
  default = false
}

# variable "identity_name" {
#   description = "Name for the User Assigned Identity"
#   type        = string
#   default     = ""
# }
variable "document_intelligence_name" {
  description = "Name for the Document Intelligence cognitive account"
  type        = string
  default     = ""
}
variable "openai_name" {
  description = "Name for the Azure OpenAI cognitive account"
  type        = string
  default     = ""
}

variable "application_type" {
  description = "Application type for Insights (e.g., web, other)"
  type        = string
  default     = "web"
}
variable "retention_in_days" {
  description = "Data retention period in days"
  type        = number
  default     = 30
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault for AML workspace"
  type        = string
  default     = ""
}
variable "inbound_network_access" {
  description = "Inbound network access restriction for AML workspace"
  type        = string
  default     = "AllowFromAzureResource"
}

variable "outbound_network_access" {
  description = "Outbound network access restriction for AML workspace"
  type        = string
  default     = "AllowOnlyApprovedOutbound"
}