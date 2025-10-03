#key pair for login to ec2 instance

resource aws_key_pair mykey {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  
}

#VPC and security group creation

resource aws_default_vpc default {
}

resource "aws_security_group" "my_sg" {
  name = "automated-sg"
  description = "this is add a terraform created security group"
  vpc_id = aws_default_vpc.default.id #interpolation
  
  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http from anywhere"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "flask app port"
  }

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }

  tags = {
    Name = "automated-sg"
  }
}


#ec2 instance creation

resource aws_instance my_instance {
    for_each = tomap({
      "Terraform-in-one-shot-micro" = "t2.micro"
      "Terraform-in-one-shot-medium" = "t2.medium"
    }) #meta argument

    depends_on = [ aws_security_group.my_sg, aws_key_pair.mykey ] #meta argument

    key_name = aws_key_pair.mykey.key_name
    security_groups = [aws_security_group.my_sg.name]
    instance_type = each.value
    ami = var.ec2_ami_id
    user_data = file("install_nginx.sh")

    root_block_device {
        volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
        volume_type = "gp3"
    }

    tags = {
      Name = each.key
      Environment = var.env
    }
  
}

#import existing instance
# resource "aws_instance" "my_new_instance" {
#   ami           = "unknown"
#   instance_type = "unknown"
  
# }

