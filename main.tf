data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "${var.name}-ecs-instance"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = var.tags
}

data "aws_iam_policy" "instance" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "instance" {
  role       = aws_iam_role.instance.name
  policy_arn = data.aws_iam_policy.instance.arn
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name}-ecs-instance"
  role = aws_iam_role.instance.name
}

resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = var.public_key
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = "${var.name}-"
  security_groups             = var.security_groups
  image_id                    = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.instance.name
  key_name                    = aws_key_pair.this.key_name

  user_data = <<EOF
#!/bin/bash
echo 'ECS_CLUSTER=${var.name}' >> /etc/ecs/ecs.config
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
EOF

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      volume_type           = try(root_block_device.value.volume_type, null)
      volume_size           = try(root_block_device.value.volume_size, null)
      iops                  = try(root_block_device.value.iops, null)
      throughput            = try(root_block_device.value.throughput, null)
      delete_on_termination = try(root_block_device.value.delete_on_termination, true)
      encrypted             = try(root_block_device.value.encrypted, false)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                  = var.name
  vpc_zone_identifier   = var.subnets
  min_size              = var.min_size
  max_size              = var.max_size
  launch_configuration  = aws_launch_configuration.this.name
  protect_from_scale_in = var.protect_from_scale_in

  lifecycle {
    ignore_changes        = [desired_capacity]
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = var.name })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_ecs_capacity_provider" "this" {
  depends_on = [aws_autoscaling_group.this]
  name       = var.name
  tags       = var.tags

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      status          = "ENABLED"
      target_capacity = var.target_capacity
    }
  }
}

resource "aws_ecs_cluster" "this" {
  name = var.name
  tags = var.tags

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE", aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    base              = var.capacity_provider_base
    weight            = var.capacity_provider_weight
  }
}
