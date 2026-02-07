output "mongodb_instance_id" {
  description = "MongoDB EC2 instance ID"
  value       = aws_instance.mongodb.id
}

output "mongodb_private_ip" {
  description = "MongoDB private IP address"
  value       = aws_instance.mongodb.private_ip
}

output "mongodb_security_group_id" {
  description = "Security group ID for MongoDB"
  value       = aws_security_group.mongodb_sg.id
}