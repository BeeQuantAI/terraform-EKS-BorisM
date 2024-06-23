resource "aws_eks_cluster" "beequant-ekscluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.beequant-eksServiceRole.arn

  vpc_config {
    # vpc_id     = var.BeeQuantAI_vpc_id
    subnet_ids = [var.BeeQuantAI_subnets_id[0], var.BeeQuantAI_subnets_id[1]]
    endpoint_private_access = true
    endpoint_public_access  = true
    # ... other configuration ...
  }
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.beequant-ekscluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.beequant-ekscluster.certificate_authority[0].data
}