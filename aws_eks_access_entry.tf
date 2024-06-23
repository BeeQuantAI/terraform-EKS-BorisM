resource "aws_eks_access_entry" "captainborisEntry" {
  cluster_name      = var.BeeQuantAI_ekscluster_name
  principal_arn     = var.captainboris_arn
#   kubernetes_groups = ["system:nodes"]
  type              = "STANDARD"
  depends_on = [module.eks]
}
resource "aws_eks_access_policy_association" "example" {
  cluster_name  = var.BeeQuantAI_ekscluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.captainboris_arn

  access_scope {
    type       = "cluster"
    # namespaces = ["example-namespace"]
  }
}