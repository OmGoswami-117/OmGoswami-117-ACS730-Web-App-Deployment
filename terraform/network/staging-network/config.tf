terraform {
  backend "s3" {
    bucket = "group5-bucket-staging"  
    key    = "staging-network/terraform.tfstate" 
    region = "us-east-1"                     
  }
}
