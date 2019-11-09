data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon", "aws-marketplace"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.2019*"]
  }

  filter {
    name   = "description"
    values = ["Amazon Linux 2 AMI 2.0.20190823.1 x86_64 HVM gp2*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "asg-tf"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true

  availability_zones  = var.availability_zones
  vpc_zone_identifier = var.subnets

  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # tags = {"Name": "manual"}
}

data "template_file" "initial_script" {
  template = "${file("${path.module}/../../${var.initial_script}")}"
  vars     = {}
}


resource "aws_key_pair" "this" {
  key_name   = "cert-ssh-key-ags"
  public_key = templatefile("${var.ssh_public_key}", {})
}

resource "aws_launch_template" "this" {
  # name          = "aws_lt"
  name_prefix   = "certification"
  image_id      = data.aws_ami.this.id
  instance_type = "t2.micro"

  monitoring {
    enabled = true
  }
  key_name = aws_key_pair.this.key_name
  tag_specifications {
    resource_type = "instance"

    tags = var.custom_tags
  }
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = "${base64encode(data.template_file.initial_script.rendered)}"
}