output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn" {
  value = aws_lb.web.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}