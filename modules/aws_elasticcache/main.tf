resource "aws_elasticache_cluster" "certification" {
  cluster_id           = "certification"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.5"
  port                 = 6379
  security_group_ids   = list(aws_security_group.elasticcache.id)

  tags = var.custom_tags
}

resource "aws_security_group" "elasticcache" {
  name        = "elasticcache-tf-certs"
  description = "ElasticCache Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "6379" # 
    to_port         = "6379"
    protocol        = "tcp"
    security_groups = var.vpc_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.custom_tags
}



