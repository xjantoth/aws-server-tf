output "server_security_group_name" {
  description = "Name of the Security Group"
  value       = aws_security_group.this.name
}
