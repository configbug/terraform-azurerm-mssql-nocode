# Resource Group
resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

# Random suffix para evitar colisiones globales
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# SQL Server
resource "azurerm_mssql_server" "this" {
  name                          = "${local.sql_server_name}-${random_string.suffix.result}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Base de datos
resource "azurerm_mssql_database" "this" {
  name        = local.db_name
  server_id   = azurerm_mssql_server.this.id
  sku_name    = var.sku_name
  max_size_gb = var.max_size_gb
  collation   = var.collation

  short_term_retention_policy {
    retention_days = var.short_term_retention_days
  }

  tags = local.common_tags
}

# Firewall personalizado
resource "azurerm_mssql_firewall_rule" "custom" {
  for_each         = { for r in var.firewall_rules : r.name => r }
  name             = each.value.name
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# Permitir servicios Azure (0.0.0.0)
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  count            = var.allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
