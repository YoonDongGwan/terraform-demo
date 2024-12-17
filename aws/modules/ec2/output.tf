output "bastion_private_ip" {
  value = aws_instance.ec2_instance.private_ip
}