locals {
  cluster_name = "3tier-cluster"
  cluster_tags = {
    Name        = local.cluster_name
    Environment = "dev"
  }
}