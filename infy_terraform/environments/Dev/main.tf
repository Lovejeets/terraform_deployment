module "resource_group" {
  source   = "../../modules/resource-group"
  rg_name  = var.env
  location = var.location
}

module "vnet" {
  source                 = "../../modules/vnet"
  for_each               = var.enable_virtual_networks ? local.virtual_networks : {}
  vnet_name              = each.key
  env                    = var.env
  location               = module.resource_group.location
  rg_name                = module.resource_group.rg_name
  address_space          = each.value.address_space
  subnet_configs         = each.value.subnet_configs
  enable_ddos_protection = each.value.enable_ddos_protection
  dns_servers            = each.value.dns_servers
}

module "storage_account" {
  source   = "../../modules/storageaccount"
  for_each = var.enable_storage_account ? local.storage_accounts : {}

  storage_account_name              = each.key
  env                               = var.env
  rg_name                           = module.resource_group.rg_name
  location                          = module.resource_group.location
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  account_kind                      = each.value.account_kind
  snet_id                           = each.value.snet_id
  vnet_id                           = each.value.vnet_id
  private_endpoint_enabled          = each.value.private_endpoint_enabled
  subresource_names                 = each.value.subresource_names
  https_traffic_only_enabled        = each.value.https_traffic_only_enabled
  shared_access_key_enabled         = each.value.shared_access_key_enabled
  min_tls_version                   = each.value.min_tls_version
  enable_blob_versioning            = each.value.enable_blob_versioning
  delete_retention_days             = each.value.delete_retention_days
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
  log_analytics_workspace_id        = module.law.log_analytics_workspace_id
  enable_storage_diagnostics        = each.value.enable_storage_diagnostics
  log_categories                    = each.value.log_categories
  metric_categories                 = each.value.metric_categories
  tags                              = each.value.tags
}


module "function_app" {
  source        = "../../modules/function_app"
  function_apps = var.enable_function_app ? local.function_apps : {}
  rg_name       = module.resource_group.rg_name
  location      = module.resource_group.location
  env           = var.env
}

module "kv" {
  for_each = var.enable_kv ? local.kv_configs : {}

  source                        = "../../modules/kv"
  name                          = each.key
  rg_name                       = module.resource_group.rg_name
  location                      = module.resource_group.location
  env                           = var.env
  sku_name                      = each.value.sku_name
  purge_protection_enabled      = each.value.purge_protection_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  enable_rbac_authorization     = each.value.enable_rbac_authorization
  subnet_id                     = each.value.subnet_id
  vnet_id                       = each.value.vnet_id
  log_analytics_workspace_id    = module.law.log_analytics_workspace_id
  public_network_access_enabled = each.value.public_network_access_enabled
  log_categories                = each.value.log_categories
  metric_categories             = each.value.metric_categories
  private_endpoint_enabled      = each.value.private_endpoint_enabled # Set to true if you want to enable private endpoint
  tags                          = each.value.tags
  depends_on                    = [module.law.log_analytics_workspace_id] # Ensure the log analytics workspace is created before KV

}

module "aks" {
  for_each = var.enable_aks ? local.aks_configs : {}

  source = "../../modules/aks"

  aks_name                   = each.key
  rg_name                    = module.resource_group.rg_name
  location                   = module.resource_group.location
  env                        = var.env
  kubernetes_version         = each.value.kubernetes_version
  private_cluster            = each.value.private_cluster
  network_plugin             = each.value.network_plugin
  load_balancer_sku          = each.value.load_balancer_sku
  os_sku                     = each.value.os_sku
  node_os_disk_type          = each.value.node_os_disk_type
  enable_host_encryption     = each.value.encryption_host
  vnet_subnet_id             = each.value.vnet_subnet_id
  default_node_pool          = each.value.default_node_pool
  additional_node_pools      = each.value.additional_node_pools
  aks_dns_service_ip         = each.value.aks_dns_service_ip
  aks_service_cidr           = each.value.aks_service_cidr
  log_analytics_workspace_id = module.law.log_analytics_workspace_id
  tags                       = each.value.tags
}

module "postgresql_flex" {
  source                        = "../../modules/postgresql_flex"
  for_each                      = var.enable_postgresql_flex ? local.postgresql_servers : {}
  psql_server_name              = each.key
  env                           = var.env
  location                      = module.resource_group.location
  rg_name                       = module.resource_group.rg_name
  subnet_id                     = each.value.subnet_id
  vnet_id                       = each.value.vnet_id
  psql_administrator_login      = each.value.psql_administrator_login
  psql_administrator_password   = each.value.psql_administrator_password
  psql_version                  = each.value.psql_version
  sku_name                      = each.value.sku_name
  storage_mb                    = each.value.storage_mb
  zone                          = each.value.zone
  high_availability_mode        = each.value.high_availability_mode
  standby_zone                  = each.value.standby_zone
  active_directory_auth_enabled = each.value.active_directory_auth_enabled
  log_analytics_workspace_id    = module.law.log_analytics_workspace_id
  log_categories                = each.value.log_categories
  metric_categories             = each.value.metric_categories
  tags                          = each.value.tags
  db_name                       = each.value.db_name
}

module "apim" {
  for_each                   = var.enable_apim ? local.apim_configs : {}
  source                     = "../../modules/apim"
  apim_name                  = each.key
  environment                = var.env
  rg_name                    = module.resource_group.rg_name
  location                   = module.resource_group.location
  subnet_id                  = each.value.subnet_id
  publisher_name             = each.value.publisher_name
  publisher_email            = each.value.publisher_email
  sku_name                   = each.value.sku_name
  log_analytics_workspace_id = module.law.log_analytics_workspace_id
  tags                       = each.value.tags
}

# # main.tf (root module)
# module "api_management_apis" {
#   source              = "../../modules/apis"
#   apis                = local.transformed_apis
#   resource_group_name = module.resource_group.rg_name
#   api_management_name = module.apim["apim3"].apim_name
# }

module "redis" {
  for_each = var.enable_redis_cache ? local.redis_cache : {}

  source                     = "../../modules/redis"
  redis_name                 = each.key
  location                   = module.resource_group.location
  rg_name                    = module.resource_group.rg_name
  env                        = var.env
  subnet_id                  = each.value.subnet_id
  redis_capacity             = each.value.redis_capacity
  redis_family               = each.value.redis_family
  redis_sku_name             = each.value.redis_sku_name
  redis_minimum_tls_version  = each.value.redis_minimum_tls_version
  redis_version              = each.value.redis_version
  vnet_id                    = each.value.vnet_id
  enable_redis_diagnostics   = each.value.enable_redis_diagnostics
  log_analytics_workspace_id = module.law.log_analytics_workspace_id
  #log_categories             = each.value.log_categories
  metric_categories = each.value.metric_categories
  tags              = each.value.tags
}

module "sqlmi" {
  source                       = "../../modules/sqlmi"
  for_each                     = var.enable_sqlmi ? local.sqlmi_servers : {}
  env                          = var.env
  sqlmi_server_name            = each.key
  rg_name                      = module.resource_group.rg_name
  location                     = module.resource_group.location
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  subnet_id                    = each.value.subnet_id
  sqlmi_db_name                = each.value.sqlmi_db_name
  enable_sqlmi_diagnostics     = each.value.enable_sqlmi_diagnostics
  log_analytics_workspace_id   = module.law.log_analytics_workspace_id
  #log_categories             = each.value.log_categories
  metric_categories           = each.value.metric_categories
  network_security_group_name = each.value.network_security_group_name
  tags                        = each.value.tags
}

module "law" {
  source            = "../../modules/log_analytics_workspace"
  rg_name           = module.resource_group.rg_name
  location          = module.resource_group.location
  env               = var.env
  law_name          = "infy"
  law_sku           = "PerGB2018" # Use the appropriate SKU for your use
  retention_in_days = 30
  tags = {
    environment = var.env
    created_by  = "terraform"
  }
}


module "vnet_peering" {
  source = "../../modules/vnet_peering"

  enable_peering = false

  hub_vnets = {
    hub1 = {
      name            = "" #Vnet name
      resource_group  = "" #vnet rg name
      vnet_id         = "" #"vnet ID. /subscriptions/<sub-id>/resourceGroups/<rg-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>"
      subscription_id = "" #<sub-id>
    }
  }

  spoke_vnets = {
    spoke1 = {
      name            = "" #Vnet name
      resource_group  = "" #vnet rg name
      vnet_id         = "" #"vnet ID. /subscriptions/<sub-id>/resourceGroups/<rg-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>"
      subscription_id = "" #<sub-id>
    }
  }
}


module "AppInsights" {
  source                     = "../../modules/appinsights"
  env                        = var.env
  location                   = var.location
  rg_name                    = module.resource_group.rg_name
  log_analytics_workspace_id = module.law.log_analytics_workspace_id
}

module "azure_identity" {
  source = "../../modules/azure_identity"

  env      = var.env
  location = var.location
  rg_name  = module.resource_group.rg_name
  #identity_name = var.identity_name

}


module "documentIntellegence" {
  source = "../../modules/documentIntelligence"

  env      = var.env
  location = var.location
  rg_name  = module.resource_group.rg_name
  sku_name = "S0"
  kind     = "FormRecognizer"

}

module "azure_openai" {
  source = "../../modules/azure_openai"

  env      = var.env
  location = "East US"
  rg_name  = module.resource_group.rg_name
  sku_name = "S0"
  kind     = "OpenAI"
}


# module "azure_machine_learning" {
#   source = "../../modules/azure-machine-learning"

#   env      = var.env
#   location = var.location
#   rg_name  = module.resource_group.rg_name
#   ml_workspace_name     = "amlworkspace"
#   vnet_id                       = module.vnet["vnet003"].vnet_id
#   subnet_id                     = module.vnet["vnet003"].subnet_ids["snet-ml"]
#   key_vault_id = module.kv["kv003"].kv_id
#   storage_account_id = module.storage_account["st003"].storage_account_id
# }


module "cosmosdb" {
  source = "../../modules/cosmosdb"

  env      = var.env
  location = var.location
  rg_name  = module.resource_group.rg_name
}
