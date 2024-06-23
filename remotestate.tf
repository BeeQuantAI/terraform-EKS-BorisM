terraform {
  backend "s3" {
    bucket         = "beequantai-tfstate-eks"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "terraform-eks-state-lock-dynamo"
  }
}