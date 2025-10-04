#key pair for login to ec2 instance

resource aws_key_pair mykey {
  key_name   = "${var.env}-infra-app-key"
  public_key = file("terra-key-ec2.pub")
  
  tags ={
    Environment = var.env
  }
}

#VPC and security group creation

resource aws_default_vpc default {
}

resource "aws_security_group" "my_sg" {
  name = "${var.env}-infra-app-sg"
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

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }

  tags = {
    Name = "${var.env}-infra-app-sg"
  }
}


#ec2 instance creation

resource aws_instance my_instance {
    count = var.instance_count

    depends_on = [ aws_security_group.my_sg, aws_key_pair.mykey ] #meta argument

    key_name = aws_key_pair.mykey.key_name
    security_groups = [aws_security_group.my_sg.name]
    instance_type = var.instance_type
    ami = var.ec2_ami_id

    root_block_device {
        volume_size = var.env == "prd" ? 20 : 10
        volume_type = "gp3"
    }

    tags = {
      Name = "${var.env}-infra-app-instance"
      Environment = var.env
    }
  
}


