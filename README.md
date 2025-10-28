# terraform-azurerm-mssql-nocode

Módulo Terraform para aprovisionar un **Azure SQL Database** listo para **Terraform Cloud no-code provisioning**.

## Prerequisitos

1. **Suscripción de Azure**: Necesitas el ID de tu suscripción de Azure
2. **Service Principal**: Para Terraform Cloud, necesitas crear un Service Principal

### Obtener el Subscription ID

```bash
# Usando Azure CLI
az account show --query id --output tsv

# O listar todas las suscripciones
az account list --query "[].{Name:name, ID:id}" --output table
```

### Crear Service Principal para Terraform Cloud

```bash
# 1. Crear el Service Principal
az ad sp create-for-rbac --name "terraform-cloud-sp" --role="Contributor" --scopes="/subscriptions/TU_SUBSCRIPTION_ID"

# El comando anterior devuelve:
# {
#   "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",        # client_id
#   "displayName": "terraform-cloud-sp",
#   "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", # client_secret
#   "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"        # tenant_id
# }

# 2. Obtener el tenant_id si no lo tienes
az account show --query tenantId --output tsv
```

### Configurar Variables en Terraform Cloud

En Terraform Cloud, configura estas variables como **Environment Variables** (sensibles):

- `ARM_SUBSCRIPTION_ID` = tu subscription_id
- `ARM_CLIENT_ID` = appId del service principal
- `ARM_CLIENT_SECRET` = password del service principal (marcar como sensible)
- `ARM_TENANT_ID` = tenant del service principal

## Campos mínimos recomendados en la UI

| Variable | Descripción | Obligatorio | Ejemplo |
|-----------|--------------|--------------|----------|
| `subscription_id` | ID de la suscripción de Azure | ✅ | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `client_id` | Application ID del Service Principal | ✅ (Cloud) | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `client_secret` | Secret del Service Principal | ✅ (Cloud) | xxxxxxxxx (sensible) |
| `tenant_id` | Tenant ID de Azure AD | ✅ (Cloud) | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `project_name` | Nombre corto del proyecto | ✅ | fraudwatch |
| `administrator_login_password` | Password seguro | ✅ | StrongPassw0rd! |
| `location` | Región de Azure | ⚙️ | eastus |
| `sku_name` | SKU de la base | ⚙️ | GP_Gen5_2 |
| `max_size_gb` | Tamaño máximo | ⚙️ | 32 |

> **Nota**: Las variables de autenticación (`client_id`, `client_secret`, `tenant_id`) son requeridas para Terraform Cloud pero opcionales para uso local con Azure CLI.

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

## Uso en Terraform Cloud

### Opción 1: Variables de Terraform (Recomendado)

En tu workspace de Terraform Cloud, configura estas variables:

**Terraform Variables:**
- `subscription_id` (sensitive)
- `client_id` (sensitive) 
- `client_secret` (sensitive)
- `tenant_id` (sensitive)
- `project_name`
- `administrator_login_password` (sensitive)
- ... otras variables según tus necesidades

### Opción 2: Variables de Entorno

**Environment Variables:**
- `ARM_SUBSCRIPTION_ID`
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET` (sensitive)
- `ARM_TENANT_ID`

> **Importante**: Si usas variables de entorno, NO definas las variables de Terraform correspondientes (`subscription_id`, `client_id`, etc.) ya que las variables de entorno tienen precedencia.

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