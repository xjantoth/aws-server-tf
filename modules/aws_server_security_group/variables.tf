variable "vpc_id" {
  description = "Main VPC ID"
  type        = string
}

variable "custom_tags" {
  description = "Custom certification tags"
  type        = map
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}
