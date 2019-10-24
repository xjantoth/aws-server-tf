
resource "aws_lb" "certification" {
  name               = "alb-certification-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = list(var.alb_security_group_id)
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = var.custom_tags
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.certification.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group" "http" {
  name     = "tf-http-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = var.custom_tags
}

resource "aws_lb_target_group_attachment" "server" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = var.aws_instance_certification_id
  port             = 80
}


