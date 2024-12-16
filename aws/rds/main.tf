resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "rds-cluster-ap-northeast-2"
  engine = var.engine
  engine_version = var.engine_version
  availability_zones = var.availability_zones
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  master_username = var.master_username
  master_password = var.master_password
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  tags = {
    Name = "rds-cluster-ap-northeast-2"
  }
  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count = 2
  identifier = "${aws_rds_cluster.rds_cluster.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.rds_cluster.id
  engine = aws_rds_cluster.rds_cluster.engine
  engine_version = aws_rds_cluster.rds_cluster.engine_version
  instance_class = "db.t3.medium"
  db_subnet_group_name = aws_rds_cluster.rds_cluster.db_subnet_group_name
  tags = {
    Name = "${aws_rds_cluster.rds_cluster.cluster_identifier}-instance-${count.index}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group-ap-northeast-2"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "rds-subnet-group-ap-northeast-2"
  }
}

resource "aws_security_group" "rds_security_group" {
  vpc_id = var.vpc_id
  name = "sgr-rds-ap-northeast-2"
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_eks" {
  count = length(var.eks_subnet_cidr_block)
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4 = element(var.eks_subnet_cidr_block,count.index)
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_bastion" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4 = "10.100.0.97/32"
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
}