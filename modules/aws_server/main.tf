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

resource "aws_security_group" "allow_tls" {
  name        = "Certification Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    description = "Allow incoming HTTP traffic"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    description = "Allow incoming SSH traffic"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name      = "Certification"
    Terraform = "true"
    Delete    = "true"
  }
}

resource "aws_instance" "certification" {
  ami           = "${data.aws_ami.this.id}"
  instance_type = "t2.micro"

  security_groups = toset(["${aws_security_group.allow_tls.name}"])
  key_name        = aws_key_pair.this.key_name

  # Notice that User Data Shell script will be copied:
  # /bin/bash /var/lib/cloud/instance/scripts/part-001
  user_data = "${data.template_file.initial_script.rendered}"
  # user_data = "${local.local_user_data}"
  tags = {
    Name      = "Certification"
    Terraform = "true"
    Delete    = "true"
  }
}

resource "aws_ami_from_instance" "certification-ami" {
  name               = "terraform-example"
  source_instance_id = aws_instance.certification.id

  tags = {
    Name      = "Certification"
    Terraform = "true"
    Delete    = "true"
  }
}