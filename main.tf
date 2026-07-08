provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "rainlabs-3tier"
      ManagedBy   = "terraform"
      Environment = "dev"
      Owner       = "rikg215"
    }
  }
}

module "network" {
  source  = "./network2"
  home_ip = var.home_ip
}

module "compute" {
  source               = "./compute"
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.private_subnet_ids[0]
  key_name             = module.ssh.key_name
  web_sg_id            = module.network.web_sg_id
  basename_in          = module.network.basename_out
  iam_instance_profile = module.iam.instance_profile_name

  depends_on = [ module.network ]
}

module "ssh" {
  source      = "./ssh"
  basename_in = module.network.basename_out
}

module "database" {
  source          = "./rds"
  priv_subnet_ids = module.network.private_subnet_ids
  web_sg_id       = module.network.web_sg_id
  vpc_id          = module.network.vpc_id
  db_pass         = var.db_pass
}

module "alb" {
  source            = "./alb"
  ec2_id            = module.compute.ec2_id
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  web_sg_id         = module.network.web_sg_id
  basename          = module.network.basename_out
}

module "iam" {
  source = "./iam"
}