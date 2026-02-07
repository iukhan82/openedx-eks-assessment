# Subnet group for RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.project_name}-mysql-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.project_name}-mysql-subnet-group"
  }
}

# Security group for RDS
resource "aws_security_group" "mysql_sg" {
  name        = "${var.project_name}-mysql-sg"
  description = "Allow MySQL access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
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
    Name = "${var.project_name}-mysql-sg"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier              = "${var.project_name}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name        # ✅ corrected
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.mysql_sg.id]
  multi_az                = var.multi_az
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project_name}-mysql"
  }
}