# Cosmos DB Account for MongoDB
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.env}-infy-cosmos"
  location            = var.location
  resource_group_name = var.rg_name
  offer_type          = "Standard"
  kind                = "MongoDB" # MongoDB API
  #enable_free_tier    = false                   # Created no (not free tier)
  #enable_multiple_write_locations = true        # High Availability enabled
  public_network_access_enabled = false # public-network-access FALSE

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "Central India"
    failover_priority = 0
  }

  geo_location {
    location          = "South India" # Read Replica Region
    failover_priority = 1
  }

  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
  }

  analytical_storage_enabled = false
}

# MongoDB Database
resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = "${var.env}-cosmosdb"
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = 4000 # Approx for M40 tier
}

# MongoDB Collection (Shard)
resource "azurerm_cosmosdb_mongo_collection" "mongo_collection" {
  name                = "${var.env}-collection"
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_mongo_database.mongo_db.name
  shard_key           = "uniqueKey" # Shard key
  throughput          = 4000
  index {
    keys   = ["_id"]
    unique = true
  }

}

# Outputs
output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_primary_key" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_key
}

# resource "azurerm_cosmosdb_account" "cosmos" {
#   name                      = "${var.env}-CosmosDB"
#   location                  = var.location
#   resource_group_name       = var.rg_name
#   offer_type                = "Standard"
#   kind                      = "MongoDB"
#   #enable_automatic_failover = false
#   geo_location {
#     location          = var.location
#     failover_priority = 0
#   }
#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }
# }

# resource "azurerm_cosmosdb_mongo_database" "example" {
#   name                = "${var.env}-CosmosDB"
#   resource_group_name = var.rg_name
#   account_name        = azurerm_cosmosdb_account.cosmos.name
#   throughput          = 400
#}

# resource "azurerm_cosmosdb_sql_container" "example" {
#   name                  = "${var.env}-container"
#   resource_group_name   = azurerm_resource_group.example.name
#   account_name          = azurerm_cosmosdb_account.example.name
#   database_name         = azurerm_cosmosdb_sql_database.main.name
#   partition_key_path    = "/definition/id"
#   partition_key_version = 1
#   throughput            = var.throughput

#   indexing_policy {
#     indexing_mode = "consistent"

#     included_path {
#       path = "/*"
#     }

#     included_path {
#       path = "/included/?"
#     }

#     excluded_path {
#       path = "/excluded/?"
#     }
#   }

#   unique_key {
#     paths = ["/definition/idlong", "/definition/idshort"]
#   }
# }