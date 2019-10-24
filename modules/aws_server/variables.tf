variable "ssh_public_key" {
  description = "SSH public key"
  type        = "string"
}

variable "initial_script" {
  description = "Initial Shell script - User Data"
  type        = "string"
}

variable "server_security_group_name" {
  description = "Server security group Name"
  type        = "string"
}

variable "custom_tags" {
  description = "Custom certification tags"
  type        = "map"
}

