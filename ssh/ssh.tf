resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web" {
  key_name   = "${var.basename_in}-web-key"
  public_key = tls_private_key.web_key.public_key_openssh
}

resource "local_file" "web_private_key" {
  content         = tls_private_key.web_key.private_key_pem
  filename        = "${path.module}/aws-3tier-key.pem"
  file_permission = "0400"
}

output "ssh_key" {
  description = "output for ssh key"
  value       = aws_key_pair.web.public_key
}

output "private_key_pem" {
  value     = tls_private_key.web_key.private_key_pem
  sensitive = true
}

output "key_name" {
  description = "Name of the AWS key pair for EC2 key_name"
  value       = aws_key_pair.web.key_name
}
