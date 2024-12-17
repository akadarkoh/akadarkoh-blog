terraform {
    backend "s3" {
      bucket = "akadarkoh-my-terraform-state"
      key = "global/s3/terraform.tfstate"
      region = "us-east-2"
      dynamodb_table = "terraform-lock-file"
    }
}