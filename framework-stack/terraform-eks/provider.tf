terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.8.0"
    }
  }
  required_version = "~> 1.3.7"  
}
