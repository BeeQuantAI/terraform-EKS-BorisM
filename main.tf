module "eks" {
    source = "terraform-aws-modules/eks/aws"
#   param  = value
    version = "20.8.3"
    cluster_name = "${local.cluster_name}"
    cluster_version = "1.29"
    subnet_ids = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id
    eks_managed_node_groups = {
        first = {
            desired_capcity = 1
            max_capacity = 2
            min_capacity = 1
            instance_type = "m5.large"
        }
    }
    cluster_endpoint_public_access = "true"
}