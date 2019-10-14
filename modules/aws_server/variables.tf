variable "ssh_public_key" {
  description = "SSH public key"
  type        = "string"
}

variable "vpc_id" {
  description = "Main VPC ID"
  type        = "string"
}

variable "initial_script" {
  description = "Initial Shell script - User Data"
  type        = "string"
}



