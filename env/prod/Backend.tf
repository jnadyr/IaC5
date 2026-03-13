terraform {
  backend "s3" { # Configure the S3 backend
    bucket = "terraform-state-jnadyr" # The name of the S3 bucket to store the Terraform state file
    key    = "Prod/terraform.tfstate" # The path within the bucket where the state file will be stored
    region = "us-east-2"
  }
}
