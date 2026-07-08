# data block ensuring I can pull ami id for ec2 instance later
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  # filter that ensures the ami_id that is applied matches regex below
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_instance" "web" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile

  user_data = <<EOF
#!/bin/bash
echo "Installing nginx on the server."
apt update
apt install nginx -y
systemctl enable nginx

echo "Adding custom nginx content."
echo "Hello from Rainlabs!" > /var/www/html/index.html
EOF

  vpc_security_group_ids = [var.web_sg_id]

  subnet_id = var.subnet_id

  tags = {
    Name = "${var.basename_in}_web_instance"
  }
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
}
