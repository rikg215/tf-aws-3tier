provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Name = module.network.basename_out
      Environment = "Testing"
    }
  }
}

module "network" {
  source  = "./network2"
  home_ip = var.home_ip
}

module "compute" {
  source    = "./compute"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_ids[0]
  key_name  = module.ssh.key_name
  web_sg_id = module.network.web_sg_id
  ssh_sg_id = module.network.ssh_sg_id
  basename_in = module.network.basename_out
}

module "ssh" {
  source = "./ssh"
}

module "database" {
  source                = "./rds"
  priv_subnet_ids       = module.network.private_subnet_ids
  ec2_security_group_id = module.network.web_sg_id
  vpc_id                = module.network.vpc_id
  db_pass               = var.db_pass
}
