resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.basename}_db_subnet"
  subnet_ids = var.priv_subnet_ids

}

resource "aws_security_group" "rds" {
  name        = "${var.basename}-rds-sg"
  description = "RDS database security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress" {
  security_group_id            = aws_security_group.rds.id
  from_port                    = "5432"
  ip_protocol                  = "tcp"
  to_port                      = "5432"
  referenced_security_group_id = var.web_sg_id
}





resource "aws_db_instance" "rds" {
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "appdb"
  username               = "appuser"
  password               = var.db_pass
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  identifier             = "web"
  storage_encrypted      = true
}
