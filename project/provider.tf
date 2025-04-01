provider "aws" {
    region = var.project_region
}

terraform {
  backend "s3" {
    bucket = "gui-projeto-terraform-state" 
    key    = "project.tfstate"
    region = "us-west-1"
  }
}