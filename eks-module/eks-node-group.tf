resource "aws_eks_node_group" "beequant-eks-node-group" {
  cluster_name    = aws_eks_cluster.beequant-ekscluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.beequant-nodeGroupServiceRole.arn
  subnet_ids = [var.BeeQuantAI_subnets_id[0], var.BeeQuantAI_subnets_id[1]]
  instance_types = var.node_group_instance_type
  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}