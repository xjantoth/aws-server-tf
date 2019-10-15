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

output "custom_ami_id" {
  description = "AMI created out of original AMI"
  value       = aws_ami_from_instance.certification-ami.id
}

output "aws_placement_group_cluster_id" {
  description = "Cluster Placement Group"
  value       = aws_placement_group.cluster.id
}

output "aws_placement_group_spread_id" {
  description = "Spread Placement Group"
  value       = aws_placement_group.spread.id
}

output "aws_placement_group_partition_id" {
  description = "Partition Placement Group"
  value       = aws_placement_group.partition.id
}

