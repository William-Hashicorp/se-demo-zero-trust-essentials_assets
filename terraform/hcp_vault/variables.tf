variable "address" {}
variable "token" {}
variable "namespace" {}
variable "vault_provider_depends_on" {
  type      = any
  default   = []
  sensitive = true
}

variable "name" {
  type    = string
  default = "hashicups"
}

variable "product_database_address" {
  type        = string
  description = "Address for the product PostgreSQL database."
}

variable "product_database_username" {
  type        = string
  description = "Admin username for the product PostgreSQL database."
}

variable "product_database_password" {
  type        = string
  description = "Admin password for the product PostgreSQL database."
  sensitive   = true
}

variable "product_database_port" {
  type        = string
  description = "Port for the product PostgreSQL database. Default 5432."
  default     = "5432"
}