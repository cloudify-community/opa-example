module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.subnets.ids

  eks_managed_node_groups = {
    group = {
      name         = var.nodegroup_name
      min_size     = var.num_nodes
      max_size     = var.num_nodes
      desired_size = var.num_nodes

      instance_types = [var.instance_size]
      capacity_type  = "ON_DEMAND"
    }
  }
}
