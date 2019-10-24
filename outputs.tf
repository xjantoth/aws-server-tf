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
  value       = module.aws_server.custom_ami_id
}

output "aws_placement_group_cluster_id" {
  description = "Cluster Placement Group"
  value       = module.aws_server.aws_placement_group_cluster_id
}

output "aws_placement_group_spread_id" {
  description = "Spread Placement Group"
  value       = module.aws_server.aws_placement_group_spread_id
}

output "aws_placement_group_partition_id" {
  description = "Partition Placement Group"
  value       = module.aws_server.aws_placement_group_partition_id
}

output "aws_vpc_default_id" {
  description = "AWS VPC default ID"
  value       = data.aws_vpc.default.id
}

output "aws_alb_security_group_id" {
  description = "Name of the ALB Security Group"
  value       = module.aws_alb_security_group.alb_security_group_id
}

output "aws_instance_certification_id" {
  description = "Server AWS instance ID"
  value       = module.aws_server.aws_instance_certification_id
}