resource "aws_security_group" "efs_sg" {
  name        = "${var.project_name}-efs-sg"
  description = "Allow NFS traffic for EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${var.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  for_each       = toset(var.subnets)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = each.value
  security_groups = [aws_security_group.efs_sg.id]
}

resource "helm_release" "efs_pv" {
  name       = "efs-pv"
  chart      = "./charts/efs-pv"
  namespace  = "openedx-lms"

  set {
    name  = "efsId"
    value = module.efs.efs_id
  }
}