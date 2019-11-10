output "aws_amis" {
  description = "AMI ID of Choosen OS"
  value       = data.aws_ami.this.id
}

output "public_ip" {
  description = "Public IP of certification instance"
  value       = [for i in aws_instance.certification : i.public_ip]
}

output "private_ip" {
  description = "Private IP of certification instance"
  value       = [for i in aws_instance.certification : i.private_ip]
}

output "availability_zone" {
  description = "Availability Zone of certification instance"
  value       = [for i in aws_instance.certification : i.availability_zone]
}


output "arn" {
  description = "ARN of certification instance"
  value       = [for i in aws_instance.certification : i.arn]
}

output "user_data" {
  description = "User Data"
  value       = [for i in aws_instance.certification : i.user_data]
}

# output "custom_ami_id" {
#   description = "AMI created out of original AMI"
#   value       = aws_ami_from_instance.certification-ami.id
# }

# output "aws_placement_group_cluster_id" {
#   description = "Cluster Placement Group"
#   value       = aws_placement_group.cluster.id
# }

# output "aws_placement_group_spread_id" {
#   description = "Spread Placement Group"
#   value       = aws_placement_group.spread.id
# }

# output "aws_placement_group_partition_id" {
#   description = "Partition Placement Group"
#   value       = aws_placement_group.partition.id
# }

output "aws_instance_certification_id" {
  description = "Server AWS instance ID"
  value       = [for i in aws_instance.certification : i.id]
}
