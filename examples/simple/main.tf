terraform {
  required_version = ">= 1.9.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "sql" {
  source = "../../modules/mssql_database"

  project_name                 = "demoapp"
  environment                  = "dev"
  location                     = "eastus"
  administrator_login_password = "StrongPassw0rd!"
  allow_azure_services         = true

  firewall_rules = [
    { name = "office", start_ip = "203.0.113.10", end_ip = "203.0.113.10" }
  ]
}
