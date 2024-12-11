data "aws_ami" "amazon_linux_2023_latest" {
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  owners = [ "amazon" ]
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name = "ec2-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "ec2_instance" {
  ami = data.aws_ami.amazon_linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]
  tags = {
    Name = var.instance_name
  }
  depends_on = [ aws_security_group.ec2_security_group ]
}

resource "aws_security_group" "ec2_security_group" {
  vpc_id = var.vpc_id
  name = var.security_group_name
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}