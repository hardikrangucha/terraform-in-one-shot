# Dev Infrastructure

module "dev-infra" {
    source = "./infra-app"
    env = "dev"
    bucket_name = "infra-app-bucket-unique"
    instance_count = 1
    instance_type = "t2.micro"
    ec2_ami_id = "ami-0f9708d1cd2cfee41" #Amazon Linux 
    hash_key = "studentID"
  
}

# Production Infrastructure
module "prd-infra" {
    source = "./infra-app"
    env = "prd"
    bucket_name = "infra-app-bucket-unique"
    instance_count = 2
    instance_type = "t2.medium"
    ec2_ami_id = "ami-0f9708d1cd2cfee41" #Amazon Linux 
    hash_key = "studentID"
  
}

# Staging Infrastructure
module "stg-infra" {
    source = "./infra-app"
    env = "stg"
    bucket_name = "infra-app-bucket-unique"
    instance_count = 1
    instance_type = "t2.small"
    ec2_ami_id = "ami-0f9708d1cd2cfee41" #Amazon Linux 
    hash_key = "studentID"
  
}