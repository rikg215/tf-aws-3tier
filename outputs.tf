output "rds_endpoint" {
  value = module.database.rds_endpoint
}
output "rds_sg_id" {
  value = module.database.rds_sg_id
}
output "ec2_id" {
  value = module.compute.ec2_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}