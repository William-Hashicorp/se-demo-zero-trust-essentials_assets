resource "null_resource" "configure-public-api" {
  depends_on = [
    aws_db_instance.products,
    aws_instance.hashicups_products_api,
    aws_instance.hashicups_public_api
  ]

  provisioner "file" {
    source      = "${path.module}/scripts/public_auth.bash"
    destination = "/home/ubuntu/public_auth.bash"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${tls_private_key.main.private_key_pem}"
      host        = aws_instance.hashicups_public_api[0].public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /home/ubuntu/public_auth.bash",
      "PRODUCT_API_HOST=${aws_instance.hashicups_products_api[0].public_ip} PRODUCT_API_PORT=9090 PAYMENT_API_HOST=${aws_instance.hashicups_products_api[0].public_ip} PAYMENT_API_PORT=8081 /home/ubuntu/public_auth.bash",
      "sudo systemctl start hashicups-public-api",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      # private_key = file("./private.key")
      private_key = "${tls_private_key.main.private_key_pem}"
      host        = aws_instance.hashicups_public_api[0].public_ip
    }
  }
}
