output "vpc_id" {
  value = aws_vpc.rainlabs_vpc.id
}

output "public_subnet_ids" {
  value = [ for s in aws_subnet.rainlab_public_subnets : s.id ]
}

output "private_subnet_ids" {
  value = [ for s in aws_subnet.rainlab_private_subnets : s.id ]
}

output "public_route_table_id" {
  value = aws_route_table.rainlabs_pubrt.id
}

output "web_sg_id" {
  value = aws_security_group.web.id
}

output "ssh_sg_id" {
  value = aws_security_group.ssh.id
}