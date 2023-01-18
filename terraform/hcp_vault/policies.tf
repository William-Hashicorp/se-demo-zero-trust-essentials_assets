resource "vault_policy" "ssh_cred_injection" {
  name = "kv-read"

  policy = <<EOT
path "secret/data/my-secret" {
  capabilities = ["read"]
}

path "secret/data/my-app-secret" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "boundary_controller" {
  name = "boundary-controller"

  policy = <<EOT
path "auth/token/lookup-self" {
capabilities = ["read"]
}

path "auth/token/renew-self" {
capabilities = ["update"]
}

path "auth/token/revoke-self" {
capabilities = ["update"]
}

path "sys/leases/renew" {
capabilities = ["update"]
}

path "sys/leases/revoke" {
capabilities = ["update"]
}

path "sys/capabilities-self" {
capabilities = ["update"]
}
EOT
}

resource "vault_policy" "hashicups_payments" {
  name = "hashicups-payments"

  policy = <<EOT
path "transit/encrypt/zero-trust-payments" {
   capabilities = [ "update" ]
}
path "transit/decrypt/zero-trust-payments" {
   capabilities = [ "update" ]
}
path "hashicups/database/creds/product" {
  capabilities = [ "read" ]
}
EOT
}

resource "vault_policy" "product_2" {
  name = "hashicups-db-dynamic-secrets"

  policy = <<EOT
path "hashicups/database/creds/product" {
  capabilities = [ "read" ]
}
EOT
}

