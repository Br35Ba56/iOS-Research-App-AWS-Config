provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket="terraform-state-12325"
    key="dev/state.tfstate"
    region="us-east-1"
  }
}