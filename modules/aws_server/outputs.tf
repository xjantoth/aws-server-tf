output "aws_amis" {
  description = "AMI ID of Choosen OS"
  value       = data.aws_ami.this.id
}

output "public_ip" {
  description = "Public IP of certification instance"
  value       = aws_instance.certification.public_ip
}

output "private_ip" {
  description = "Private IP of certification instance"
  value       = aws_instance.certification.private_ip
}

output "availability_zone" {
  description = "Availability Zone of certification instance"
  value       = aws_instance.certification.availability_zone
}

output "arn" {
  description = "ARN of certification instance"
  value       = aws_instance.certification.arn
}

output "user_data" {
  description = "User Data"
  value       = aws_instance.certification.user_data
}
