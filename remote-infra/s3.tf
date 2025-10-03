resource "aws_s3_bucket" "remote_s3" {
    bucket = "terraform-remote-state-bucket-unique-name-12345"

    tags = {
        Name = "Terraform Remote State Bucket"
    }
  
}