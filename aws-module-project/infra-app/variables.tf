variable "env" {
    description = "This is the environment for infra"
    type        = string
  
}

variable "bucket_name" {
    description = "The name of the S3 bucket name for infra"
    type        = string
}

variable "instance_count" {
    description = "This is the number of ec2 instances for infra"
    type        = number
}

variable "instance_type" {
    description = "This is the instance type for ec2 instances for infra"
    type        = string
}

variable "ec2_ami_id" {
    description = "This is the AMI ID for ec2 instances for infra"
    type        = string
}

variable "hash_key" {
    description = "This is the hash key for the DynamoDB table"
    type        = string
}