variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "basename" {
  default = "rainlabs"
}


variable "public_subnets" {
  type = map(object(
    {
      az   = string
      cidr = string
  }))
  default = {
    sub-1 = {
      az   = "us-east-1a"
      cidr = "10.0.1.0/24"
    }
    sub-2 = {
      az   = "us-east-1b"
      cidr = "10.0.2.0/24"
    }
  }
}

variable "private_subnets" {
  type = map(object(
    {
      az   = string
      cidr = string
  }))
  default = {
    sub-1 = {
      az   = "us-east-1a"
      cidr = "10.0.10.0/24"
    }
    sub-2 = {
      az   = "us-east-1b"
      cidr = "10.0.11.0/24"
    }
  }
}

variable "home_ip" {
  type = string
}
