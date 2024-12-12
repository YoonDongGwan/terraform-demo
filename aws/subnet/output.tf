output "subnet_id" {
  value = {for key, subnet in aws_subnet.subnet : key => subnet.id}
}