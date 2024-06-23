# data "aws_eks_cluster" "cluster" {
#   name = var.BeeQuantAI_ekscluster_name
# }
provider "helm" {
  kubernetes {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.BeeQuantAI_ekscluster_name]
      command     = "aws"
    }
  }
}