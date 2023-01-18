resource "null_resource" "configure-rds-postgres" {
  depends_on = [
    aws_db_instance.products
  ]

  # triggers = {
  #   build_number = timestamp()
  # }

# use SSH to connect to the public IP of the ubuntu vm, and sync the scripts folder to the /home/ubuntu folder
  provisioner "file" {
#    source      = "scripts/"
#    destination = "/home/ubuntu/"
    source      = "${path.module}/scripts/products.sql"
    destination = "/home/ubuntu/products.sql"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${tls_private_key.main.private_key_pem}"
      host        = aws_instance.hashicups_frontend[0].public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "export PGPASSWORD=${var.database_password}",
      "sudo apt-get install -y postgresql-client",
      "psql -h ${aws_db_instance.products[0].address} -U ${var.database_username} -d products -f './products.sql'",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${tls_private_key.main.private_key_pem}"
      host        = aws_instance.hashicups_frontend[0].public_ip
    }
  }

  provisioner "local-exec" {
    command     = "export PGPASSWORD=${var.database_password} "
    interpreter = ["/usr/bin/bash", "-c"]
  }

  # provisioner "local-exec" {
  #   command     = "export PGPASSWORD=${var.database_password} && psql -h ${aws_db_instance.products[0].address} -U ${var.database_username} -d products -f ${path.module}/scripts/products.sql"
  #   interpreter = ["/usr/bin/bash", "-c"]
  # }
}
