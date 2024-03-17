## VPC For Eks

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Eks-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.availability-zones.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }
}

data "aws_availability_zones" "availability-zones" {
}

## Eks  Cluster Module

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.small"]
    }

  }

  tags = {
    Name        = "Eks-Cluster"
    Environment = "dev"
    Terraform   = "true"
  }
}
