
resource "aws_security_group" "app_sg" {
  name   = "${var.project_name}-app-sg"
  vpc_id = var.vpc_id
  description = "Allow http from ALB and ssh from admin (adjust)"
  tags = var.tags

  ingress {
    description = "HTTP from ALB"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (adjust in production)"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix = "${var.project_name}-lt-"
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.app_instance_type

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
    associate_public_ip_address = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name_prefix = "${var.project_name}-asg-"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  launch_template {
    id = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.private_subnets
  tags = [
    for k,v in var.tags : {
      key = k
      value = v
      propagate_at_launch = true
    }
  ]
  health_check_type = "EC2"
  wait_for_capacity_timeout = "10m"
}

output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}
