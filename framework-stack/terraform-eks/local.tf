locals {
  # Do NOT edit any of these
  env     = "perf-test"
  project = "photon"

  # Do NOT edit any of these manually
  vpc_id = "vpc-0532050964a3e485c"
  gateway_id = "igw-083f3d526f1cfa12f"


  # Below can be updated as per requirement/preferences

  # Make sure region is same as used with ansible scripts
  region = "us-east-1"

  common_tags = {
    Environment = local.env
    Project     = local.project
  }
  
  vpc_ipblock = "10.20.0.0/16"
  public_subnet_1a = "10.20.2.0/24"
  public_subnet_1b = "10.20.3.0/24"
  private_subnet_1a = "10.20.4.0/24"
  private_subnet_1b = "10.20.5.0/24"
  private_subnet_1c = "10.20.6.0/24"
  eks_cluster_name = "${local.env}_${local.project}_eks_cluster"
  k8_version = "1.24"
  eks_worker_node_instance_type = "t2.large"
  min_worker_node = 1
  max_worker_node = 5
  desired_worker_node = 3
  max_unavailable_node = 1

}
