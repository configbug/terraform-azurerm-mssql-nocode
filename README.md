# terraform-azurerm-mssql-nocode

Módulo Terraform para aprovisionar un **Azure SQL Database** listo para **Terraform Cloud no-code provisioning**.

## Campos mínimos recomendados en la UI

| Variable | Descripción | Obligatorio | Ejemplo |
|-----------|--------------|--------------|----------|
| `project_name` | Nombre corto del proyecto | ✅ | fraudwatch |
| `administrator_login_password` | Password seguro | ✅ | StrongPassw0rd! |
| `location` | Región de Azure | ⚙️ | eastus |
| `sku_name` | SKU de la base | ⚙️ | GP_Gen5_2 |
| `max_size_gb` | Tamaño máximo | ⚙️ | 32 |

## Ejemplo local

```hcl
module "sql" {
  source = "../../modules/mssql_database"

  project_name                 = "demoapp"
  environment                  = "dev"
  location                     = "eastus"
  administrator_login_password = "StrongPassw0rd!"
  allow_azure_services         = true
}