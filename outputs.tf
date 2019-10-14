output "aws_amis" {
  description = "AMI ID of Choosen OS"
  value       = module.aws_server.aws_amis
}

output "public_ip" {
  description = "Public IP of certification instance"
  value       = module.aws_server.public_ip
}

output "private_ip" {
  description = "Private IP of certification instance"
  value       = module.aws_server.private_ip
}

output "availability_zone" {
  description = "Availability Zone of certification instance"
  value       = module.aws_server.availability_zone
}

output "arn" {
  description = "ARN of certification instance"
  value       = module.aws_server.arn
}

output "user_data" {
  description = "User Data"
  value       = module.aws_server.user_data
}

output "custom_ami_id" {
  description = "AMI created out of original AMI"
  value = module.aws_server.custom_ami_id
}
