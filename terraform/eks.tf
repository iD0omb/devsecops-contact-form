module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.26.0"

  name               = "dso-eks"
  kubernetes_version = "1.36"

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  #API endpoint reachable only from my IP
  endpoint_public_access       = true             # Allows inbound connections
  endpoint_public_access_cidrs = [var.admin_cidr] # Restricts those connections to my personal IP Address
  # *IP ADDRESSES COULD CHANGE, IF kubectl times out one day,
  # double check current IP with https://checkip.amazonaws.com and update admin_cidr

  # Lets TerraformAdmin run kubectl against the cluster
  enable_cluster_creator_admin_permissions = true

  #EKS Logging
  enabled_log_types = ["api", "audit", "authenticator"]
  # Logs API Server operations
  # Actions taken by users and system components on the cluster
  # Who logged in

  addons = {
    coredns    = {}                        # Internal DNS resolution
    kube-proxy = {}                        # Manages network routing rules per node 
    vpc-cni    = { before_compute = true } # Container Network Interface allowing the pod to receive Native IP addresses from the VPC
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD" # Standard Linux 2023 OS image
      instance_types = ["t3.medium"]            # Low cost instances
      min_size       = 1
      max_size       = 2
      desired_size   = 2 # 1 per AZ
    }
  }


}