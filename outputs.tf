#output "private_key" {
#  value = module.compute.private_key
#  sensitive = true
#}
#
output "public_ip" {
  value = module.compute.public_ip
}
