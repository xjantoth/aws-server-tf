variable "custom_tags" {
  description = "Custom certification tags."
  type        = map
}

variable "alb_security_group_id" {
  description = "ALB Security Group ID."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets."
  type        = list
}

variable "vpc_id" {
  description = "Main VPC ID."
  type        = string
}

variable "aws_instance_certification_id" {
  description = "Server ID to be attached to a target group."
  type        = list
}


