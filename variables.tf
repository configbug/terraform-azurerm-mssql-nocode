variable "project_name" {
  description = "Nombre corto del proyecto. Se usará como prefijo en todos los recursos."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.project_name))
    error_message = "Solo se permiten letras minúsculas, números o guiones (3-24 caracteres)."
  }
}

variable "environment" {
  description = "Entorno (dev, cert, prod)."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "cert", "prod"], var.environment)
    error_message = "Debe ser uno de: dev, cert o prod."
  }
}

variable "location" {
  description = "Región de Azure."
  type        = string
  default     = "eastus"
}

variable "administrator_login" {
  description = "Usuario administrador SQL Server."
  type        = string
  default     = "sqladminuser"
}

variable "administrator_login_password" {
  description = "Contraseña del usuario administrador SQL Server."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU de la base de datos (por ejemplo, GP_Gen5_2, S0, P1)."
  type        = string
  default     = "GP_Gen5_2"
}

variable "max_size_gb" {
  description = "Tamaño máximo de la base en GB."
  type        = number
  default     = 32
}

variable "collation" {
  description = "Collation SQL Server."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "minimum_tls_version" {
  description = "Versión mínima de TLS permitida."
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Permitir acceso público al servidor."
  type        = bool
  default     = true
}

variable "allow_azure_services" {
  description = "Permitir acceso desde servicios Azure (0.0.0.0)."
  type        = bool
  default     = false
}

variable "firewall_rules" {
  description = "Lista de reglas de firewall personalizadas."
  type = list(object({
    name     = string
    start_ip = string
    end_ip   = string
  }))
  default = []
}

variable "short_term_retention_days" {
  description = "Días de retención para backups a corto plazo (7–35)."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Etiquetas comunes para todos los recursos."
  type        = map(string)
  default = {
    managed_by  = "terraform"
    provisioned = "nocode"
  }
}
