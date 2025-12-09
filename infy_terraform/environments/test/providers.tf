terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0"
}

# terraform {
#   backend "azurerm" {
#     access_key           = ""  # Can also be set via `ARM_ACCESS_KEY` environment variable.
#     storage_account_name = ""                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
#     container_name       = "terraform"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
#     key                  = "test.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
#   }
# }


provider "azurerm" {
  features {}
}
