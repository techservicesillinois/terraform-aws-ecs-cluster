locals {
  ec2         = var.enable_ec2
  name_prefix = format("%s-ecs-cluster-", var.name)
  subnet_ids  = (var.enable_ec2) ? flatten([for v in module.get-subnets : v.subnets.ids]) : null
  template = file(
    var.template == null ? format("%s/ecs.tpl", path.module) : var.template,
  )
  security_group_ids = distinct(
    concat(
      data.aws_security_group.selected.*.id,
      var.security_group_ids,
    ),
  )
  vpc_id = (var.enable_ec2) ? element(distinct([for v in module.get-subnets : v.vpc.id]), 0) : null
}

resource "aws_ecs_cluster" "default" {
  name = var.name
  tags = merge({ Name = var.name }, var.tags)

  dynamic "setting" {
    for_each = { for s in var.setting : s.name => s.value }
    content {
      name  = setting.key
      value = setting.value
    }
  }
}

resource "aws_autoscaling_group" "default" {
  count = var.enable_ec2 ? 1 : 0

  desired_capacity     = var.desired_capacity
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.default[0].name
  min_size             = var.min_size
  max_size             = var.max_size
  name_prefix          = local.name_prefix
  vpc_zone_identifier  = local.subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge({ Name = var.name }, var.tags)
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_launch_configuration" "default" {
  count = var.enable_ec2 ? 1 : 0

  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  image_id                    = data.aws_ami.selected[0].id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  name_prefix                 = local.name_prefix
  security_groups             = concat([aws_security_group.default[0].id], local.security_group_ids)
  user_data                   = data.template_file.selected[0].rendered

  # aws ec2 describe-images --image-ids ami-04b61a4d3b11cc8ea
  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = 220 # Volume size in gigabytes.
  }

  # Always use name_prefix with this lifecycle setting
  lifecycle {
    create_before_destroy = true
  }
}
