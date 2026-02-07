output "mysql_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.address
}

output "mysql_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.mysql.port
}

output "mysql_security_group_id" {
  description = "Security group ID for MySQL"
  value       = aws_security_group.mysql_sg.id
}