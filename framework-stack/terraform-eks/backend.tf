terraform {
  backend "s3" {
    bucket         = "dummy-perf-testing-t2.medium-perf-control-host"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}
