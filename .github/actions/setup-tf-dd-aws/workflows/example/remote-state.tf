terraform {
  backend "s3" {
    bucket         = "terraform-remote-state"
    dynamodb_table = "terraform-lock"
    key            = "test_dd_eks_statefile"
    region         = "us-gov-east-1"
  }
}
