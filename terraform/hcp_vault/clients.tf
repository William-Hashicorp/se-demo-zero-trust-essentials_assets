locals {
  payments_host_attributes = lookup(var.target_ec2_attributes, "payments", "null")
}

resource "null_resource" "vault_client_config_files" {

  provisioner "file" {
    source      = "${path.module}/scripts/payments_update.bash"
    destination = "/home/ubuntu/payments_update.bash"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      # private_key = tls_private_key.hashicups.main.private_key_pem
      private_key = "${var.my_private_key}"
      host        = local.payments_host_attributes["ip"]
    }
  }
}

resource "null_resource" "vault_client_config" {
  depends_on = [
    null_resource.vault_client_config_files
  ]

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/payments_update.bash",
      "VAULT_ADDR=${var.address} VAULT_TOKEN=${vault_token.payments_transit_encryption.client_token} /home/ubuntu/payments_update.bash"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${var.my_private_key}"
      host        = local.payments_host_attributes["ip"]
    }
  }
}

resource "null_resource" "consul-template_config_files" {
  # use trigger to force refresh consul_template config files every time.
  triggers = {
    build_number = timestamp()
  }

  provisioner "file" {
    source      = "${path.module}/scripts/enable_consul-template.bash"
    destination = "/home/ubuntu/enable_consul-template.bash"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      # private_key = tls_private_key.hashicups.main.private_key_pem
      private_key = "${var.my_private_key}"
      host        = local.payments_host_attributes["ip"]
    }
  }
}

resource "null_resource" "consul-template_config" {
  depends_on = [
    null_resource.consul-template_config_files
  ]

  # use trigger to force refresh consul_template config files every time.
  triggers = {
    build_number = timestamp()
  }

# use the token "db_dynamic_secret_token" as it has the policy to read the dynamic db path.
# install and run enable_consul-template.bash to refresh db credential in the app config file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/enable_consul-template.bash",
      "VAULT_ADDR=${var.address} VAULT_TOKEN=${vault_token.db_dynamic_secret_token.client_token} VAULT_NAMESPACE=${var.namespace} DB_HOST=${var.product_database_address} /home/ubuntu/enable_consul-template.bash"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${var.my_private_key}"
      host        = local.payments_host_attributes["ip"]
    }
  }
}
