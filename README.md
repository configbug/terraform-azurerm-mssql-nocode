# terraform-azurerm-mssql-nocode

Módulo Terraform para aprovisionar un **Azure SQL Database** listo para **Terraform Cloud no-code provisioning**.

## Prerequisitos

1. **Suscripción de Azure**: Necesitas el ID de tu suscripción de Azure
2. **Autenticación**: Configurar las credenciales de Azure (CLI, Service Principal, etc.)

### Obtener el Subscription ID

```bash
# Usando Azure CLI
az account show --query id --output tsv

# O listar todas las suscripciones
az account list --query "[].{Name:name, ID:id}" --output table
```

## Campos mínimos recomendados en la UI

| Variable | Descripción | Obligatorio | Ejemplo |
|-----------|--------------|--------------|----------|
| `subscription_id` | ID de la suscripción de Azure | ✅ | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `project_name` | Nombre corto del proyecto | ✅ | fraudwatch |
| `administrator_login_password` | Password seguro | ✅ | StrongPassw0rd! |
| `location` | Región de Azure | ⚙️ | eastus |
| `sku_name` | SKU de la base | ⚙️ | GP_Gen5_2 |
| `max_size_gb` | Tamaño máximo | ⚙️ | 32 |

## Uso local

1. **Copia el archivo de ejemplo**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edita terraform.tfvars** con tus valores:
   ```hcl
   subscription_id = "tu-subscription-id-aqui"
   project_name    = "mi-proyecto"
   environment     = "dev"
   location        = "East US"
   # ... otros valores
   ```

3. **Ejecuta Terraform**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Ejemplo local

```hcl
module "sql" {
  source = "../../modules/mssql_database"

  subscription_id              = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  project_name                 = "demoapp"
  environment                  = "dev"
  location                     = "eastus"
  administrator_login_password = "StrongPassw0rd!"
  allow_azure_services         = true
}