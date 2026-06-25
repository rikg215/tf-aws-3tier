provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./network2"
}

module "compute" {
  source    = "./compute"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_ids[0]
  key_name  = module.ssh.key_name
  web_sg_id = module.network.web_sg_id
  ssh_sg_id = module.network.ssh_sg_id
}

module "ssh" {
  source = "./ssh"
}
