output "subnet_id" {
  value = {for key, subnet in aws_subnet.subnet : key => subnet.id}
}
output "cidr_block" {
  value = {for key, subnet in aws_subnet.subnet : key => subnet.cidr_block}
}