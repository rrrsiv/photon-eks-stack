data aws_ssm_parameter "eks_ami_release_version" {
    name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_cluster" "eks" {
  name = local.eks_cluster_name
  vpc_config {
    subnet_ids              = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id, aws_subnet.private-subnet-1c.id]
    security_group_ids      = [aws_security_group.eks-cluster-sg.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  enabled_cluster_log_types = ["api", "audit"]
  role_arn                  = aws_iam_role.eks-cluster-role.arn
  version                   = local.k8_version
  tags                      = {
    Name = "${local.env}-${local.project}-eks-cluster"
  }
}


############### Nodes #######################


resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.env}-${local.project}-eks-worker-node"
  node_role_arn   = aws_iam_role.eks-worker-role.arn
  subnet_ids      = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id, aws_subnet.private-subnet-1c.id]
  ami_type       = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  disk_size      = 10
  instance_types = [local.eks_worker_node_instance_type]
  tags                      = {
    Name = "${local.env}-${local.project}-eks-cluster-ng"
  }
  #ec2_ssh_key = "nagarro"
  scaling_config {
    desired_size = local.desired_worker_node
    max_size     = local.max_worker_node
    min_size     = local.min_worker_node
  }

  update_config {
    max_unavailable = local.max_unavailable_node
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-role-nodepolicy,
    aws_iam_role_policy_attachment.eks-worker-role-cnipolicy,
    aws_iam_role_policy_attachment.eks-worker-role-servicepolicy,
    aws_iam_role_policy_attachment.eks-worker-role-containerregistry,
    aws_iam_role_policy_attachment.eks-worker-role-AmazonSSMFullAccess,
    aws_iam_role_policy_attachment.eks-worker-role-AdministratorAccess,
    aws_iam_role_policy_attachment.eks-worker-role-AmazonEC2RoleforSSM
  ]
}