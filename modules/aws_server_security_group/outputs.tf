output "server_security_group_name" {
  description = "Name of the Security Group"
  value       = aws_security_group.this.name
}

output "server_security_group_id" {
  description = "The Security Group ID"
  value       = aws_security_group.this.id
}