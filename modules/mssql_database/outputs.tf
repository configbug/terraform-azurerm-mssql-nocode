output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "Nombre del Resource Group creado."
}

output "sql_server_name" {
  value       = azurerm_mssql_server.this.name
  description = "Nombre del servidor SQL."
}

output "sql_server_fqdn" {
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
  description = "FQDN del servidor SQL."
}

output "database_name" {
  value       = azurerm_mssql_database.this.name
  description = "Nombre de la base de datos."
}

output "connection_string_template" {
  description = "Plantilla de cadena de conexión segura."
  value = format(
    "Server=tcp:%s,1433;Initial Catalog=%s;User ID=%s;Password=<REPLACE_ME>;Encrypt=True;Connection Timeout=30;",
    azurerm_mssql_server.this.fully_qualified_domain_name,
    azurerm_mssql_database.this.name,
    var.administrator_login
  )
}
