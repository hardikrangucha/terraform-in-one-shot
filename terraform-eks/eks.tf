module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # cluster info (control plane)
  name = local.name
  endpoint_public_access = true
  kubernetes_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # control plane network
  control_plane_subnet_ids = module.vpc.intra_subnets

  # managed node groups (no defaults block in v21)
  eks_managed_node_groups = {
    tws-cluster-ng = {
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      capacity_type = "SPOT"

      attach_cluster_primary_security_group = true
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}

# addons must be separate resources in v21
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"

}

resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"

}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"

}