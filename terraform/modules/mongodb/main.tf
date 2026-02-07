# Security Group for MongoDB
resource "aws_security_group" "mongodb_sg" {
  name        = "${var.project_name}-mongodb-sg"
  description = "Allow MongoDB access from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "MongoDB from VPC"
    from_port   = var.mongo_port
    to_port     = var.mongo_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust to match your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-mongodb-sg"
  }
}

# EC2 Instance for MongoDB
resource "aws_instance" "mongodb" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (update to region-specific)
  instance_type          = var.instance_type
  subnet_id              = element(var.subnets, 0)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  root_block_device {
    volume_size = var.mongo_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-mongodb"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable corretto8
              sudo amazon-linux-extras install epel -y
              sudo yum install -y mongodb-org
              sudo systemctl start mongod
              sudo systemctl enable mongod
              EOF
}