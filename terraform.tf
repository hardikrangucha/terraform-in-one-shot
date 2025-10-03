terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
        }
    }

    #remote state configuration
    backend "s3" {
        bucket = "terraform-remote-state-bucket-unique-name-12345"
        key = "terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "terraform-state-table"
    }
}

