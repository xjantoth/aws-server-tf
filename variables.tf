variable "aws_region" {
  type        = "string"
  description = "AWS region"
}

variable "aws_access_key" {
  type        = "string"
  description = "AWS region"
}
variable "aws_secret_key" {
  type        = "string"
  description = "AWS region"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = "string"
}

variable "initial_script" {
  description = "Initial Shell script - User Data"
  type        = "string"
}

variable "custom_tags" {
  description = "Custom certification tags"
  type        = "map"
}

variable "number_of_inatances" {
  description = "Number of AWS EC2 instances to be created"
  type        = number
}

variable "enable_asg" {
  description = "Enable ASG true/false"
  type        = number
}