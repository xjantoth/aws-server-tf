
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

locals {
  tcp_ports = ["80", "8080"]
  port_instance_arn_map = {
    for jan, katka in setproduct(local.tcp_ports, var.aws_instance_certification_id) :
    jan => concat(katka, list(lookup(lookup({ for j, k in aws_lb_target_group.http : j => k }, katka[0]), "arn")))
  }

}

resource "aws_lb_target_group" "http" {
  for_each = toset(local.tcp_ports)

  name     = "tf-http-alb-tg-${each.value}"
  port     = each.value
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 20
    enabled         = true
  }

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200"
  }

  tags = {
    for a, b in var.custom_tags :
    a => (a == "Name" ? format("%s-%s", "tg-alb", each.value) : b)
  }
}

resource "aws_lb_listener" "front_end" {
  for_each = toset(local.tcp_ports)

  load_balancer_arn = aws_lb.certification.arn
  port              = each.value
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = lookup(lookup({ for j, k in aws_lb_target_group.http :
      j => k
    }, each.key), "arn")

  }
}


resource "aws_lb_target_group_attachment" "http" {
  for_each = local.port_instance_arn_map
  #                     "0" = [
  #  each.value[0]  =>    "80",
  #  each.value[1]  =>    "i-0013a71ebf24f08e4",
  #  each.value[2]  =>    "arn:aws:elasticloadbalancing:eu-central-1:8987...90789:targetgroup/tf-http-alb-tg-80/90bd02524cc415d1",
  #                     ]
  #                     "1" = [
  #                       "80",
  #                       "i-02b1b7f8763beba6d",
  #                       "arn:aws:elasticloadbalancing:eu-central-1:8987...90789:targetgroup/tf-http-alb-tg-80/90bd02524cc415d1",
  #                     ]
  #                     "2" = [
  #                       "8080",
  #                       "i-0013a71ebf24f08e4",
  #                       "arn:aws:elasticloadbalancing:eu-central-1:8987...789:targetgroup/tf-http-alb-tg-8080/d513ffaf659fc4f0",
  #                     ...

  target_group_arn = each.value[2] # the third element (index [2]) from an example list above represents ARN
  target_id        = each.value[1] # the second element (index [1]) from an example list above represents EC2 id
  port             = each.value[0] # the first element (index [0]) from an example list above represents PORT
}





