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
  count = var.enable_asg

  name                      = "asg-tf"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true

  availability_zones  = var.availability_zones
  vpc_zone_identifier = var.subnets

  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # tags = [for key,value in var.custom_tags:  map(key, (key == "Name" ? format("%s-%s", "asg-tf", value) : value))]
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

  block_device_mappings {
    device_name = "/dev/sdb"

    ebs {
      delete_on_termination = true
      volume_size           = 1
      volume_type           = "standard"
    }
  }

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


resource "aws_efs_file_system" "efs" {
  count = var.enabled_asg_efs ? 1 : 0

  tags                            = var.custom_tags
  encrypted                       = true
  performance_mode                = "generalPurpose"
  provisioned_throughput_in_mibps = 0
  throughput_mode                 = "bursting"
}

resource "aws_efs_mount_target" "efs" {
  count = var.enabled_asg_efs && length(var.subnets) > 0 ? length(var.subnets) : 0

  file_system_id = join("", aws_efs_file_system.efs.*.id)
  # ip_address      = data.aws_instances.asg_instances.public_ips[count.index]
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.efs.*.id)]
}


# data "aws_instances" "asg_instances" {
#   filter {
#     name   = "tag:Name"
#     values = ["Certification"]
#   }
#   instance_state_names = ["running"]
# }


resource "aws_security_group" "efs" {
  count       = var.enabled_asg_efs ? 1 : 0
  name        = "efs-tf-asg-certs"
  description = "EFS Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049" # NFS
    to_port         = "2049"
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