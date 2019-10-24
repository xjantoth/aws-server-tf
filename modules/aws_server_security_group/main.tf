locals {
  # Ids for multiple sets of EC2 instances, merged together
  allowed_tcp_ports = ["80"]
}

resource "aws_security_group" "this" {
  name        = "Server Certification Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.allowed_tcp_ports

    content {
      description = "Allow incoming SSH traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # Please restrict your ingress to only necessary IPs and ports.
      # Opening to 0.0.0.0/0 can lead to security vulnerabilities.

      # cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
      security_groups = list(var.alb_security_group_id)
    }
  }

  dynamic "egress" {
    for_each = local.allowed_tcp_ports

    content {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = var.custom_tags
}
