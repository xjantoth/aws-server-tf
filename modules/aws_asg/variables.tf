variable "custom_tags" {
  description = "Custom certification tags"
  type        = "map"
}
variable "initial_script" {
  description = "Initial Shell script - User Data"
  type        = "string"
}

variable "availability_zones" {
  description = "List of availability zones for chosen region e.g. region: eu-central-1"
  type        = "list"
}

variable "subnets" {
  description = "List of available subnets"
  type        = "list"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = "list"
}

variable "target_group_arns" {
  description = "List of Target Group ARNs"
  type        = "list"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = "string"
}