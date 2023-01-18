variable "address" {}
variable "datacenter" {}
variable "token" {}
variable "target_ec2_attributes" {
  type = any
}
variable "target_ec2_unique" {
  type = any
}

# declare variables for private key
variable "my_private_key" {
  type        = string
  description = "Private key generated for hashicups."
  sensitive   = true
}

# declare variables for consul client config file
variable "consul_ca_file" {
  type        = string
  description = "consul_ca_file for consul client."
  sensitive   = true
}

variable "consul_config_file" {
  type        = string
  description = "consul_config_file for consul client."
  sensitive   = true
}

variable "consul_secret_id" {
  type        = string
  description = "consul_secret_id for consul client."
  sensitive   = true
}
