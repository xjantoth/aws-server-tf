resource "aws_db_instance" "certification" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "mydb"
  username                = "foo"
  password                = "foobarbaz"
  parameter_group_name    = "default.mysql5.7"
  vpc_security_group_ids  = list(aws_security_group.rds.id)
  backup_retention_period = 3
  backup_window           = "03:00-06:00"

  tags = var.custom_tags
}


resource "aws_security_group" "rds" {
  name        = "rds-tf-certs"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "3306" # 
    to_port         = "3306"
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