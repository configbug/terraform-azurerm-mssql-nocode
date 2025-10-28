locals {
  rg_name         = "rg-${var.project_name}-${var.environment}"
  sql_server_name = "sql-${var.project_name}-${var.environment}"
  db_name         = "sqldb-${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      project     = var.project_name
      environment = var.environment
      region      = upper(var.location)
    }
  )
}
