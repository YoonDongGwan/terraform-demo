resource "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks-cluster.arn
  vpc_config {
    subnet_ids = [ var.private_subnet_a, var.private_subnet_b ]
    security_group_ids = [ aws_security_group.eks-ap-northeast-2-cluster.id ]
    endpoint_private_access = true
    endpoint_public_access = false
  }
  access_config {
    authentication_mode = "API"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn = aws_iam_role.eks-node-group.arn
  subnet_ids = [ var.private_subnet_a, var.private_subnet_b ]
  capacity_type = "ON_DEMAND"
  scaling_config {
    desired_size = var.scaling_desired_size
    max_size = var.scaling_max_size
    min_size = var.scaling_min_size
  }
  instance_types = [ var.node_group_instance_type ]
  depends_on = [ aws_iam_role.eks-node-group ]
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_security_group" "eks_ap-northeast_2_cluster" {
  name = "sgr-eks-ap-northeast-2-cluster"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_bastion" {
  security_group_id = aws_security_group.eks_ap_northeast_2_cluster.id
  cidr_ipv4 = "${var.bastion_ip}/32"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

