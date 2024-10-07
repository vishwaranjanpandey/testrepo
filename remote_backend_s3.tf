terraform {
  backend "s3" {
    key = "key/terraform1.tfstate"
    bucket = "vishwaa"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}