variable "custom_tags" {
  description = "Custom certification tags."
  type        = "map"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs from servers"
  type        = "list"
}

variable "vpc_id" {
  description = "Main VPC ID."
  type        = "string"
}






