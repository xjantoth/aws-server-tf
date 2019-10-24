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

resource "aws_key_pair" "this" {
  key_name   = "cert-ssh-key"
  public_key = templatefile("${var.ssh_public_key}", {})
}

data "template_file" "initial_script" {
  template = "${file("${path.module}/../../${var.initial_script}")}"
  vars     = {}
}

resource "aws_instance" "certification" {
  ami           = "${data.aws_ami.this.id}"
  instance_type = "t2.micro"

  security_groups = toset([var.server_security_group_name])
  key_name        = aws_key_pair.this.key_name

  # Notice that User Data Shell script will be copied:
  # /bin/bash /var/lib/cloud/instance/scripts/part-001
  user_data = "${data.template_file.initial_script.rendered}"
  # user_data = "${local.local_user_data}"

  placement_group = aws_placement_group.partition.id

  tags = var.custom_tags
}

resource "aws_ami_from_instance" "certification-ami" {
  name               = "terraform-example"
  source_instance_id = aws_instance.certification.id

  tags = var.custom_tags
}

# Placement Group
resource "aws_placement_group" "cluster" {
  name     = "cluster-placement-group"
  strategy = "cluster"
}

resource "aws_placement_group" "spread" {
  name     = "spread-placement-group"
  strategy = "spread"
}

resource "aws_placement_group" "partition" {
  name     = "partition-placement-group"
  strategy = "partition"
}