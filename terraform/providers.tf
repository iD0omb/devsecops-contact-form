# How the provider is connected
provider "aws" {
  region = "ap-southeast-1" # Provider region
  # Credentials are not stored here.
}

# Lets Terraform install helm charts into the EKS cluster,
# authenticating the same way kubectl does (via the AWS CLI)
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "ap-southeast-1"]
    }
  }

}