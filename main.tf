locals {
  ec2        = var.enable_ec2_container_instances
  subnet_ids = flatten([for v in module.get-subnets : v.subnets.ids])
  template = file(
    var.template == "" ? format("%s/ecs.tpl", path.module) : var.template,
  )
  security_group_ids = distinct(
    concat(
      data.aws_security_group.selected.*.id,
      var.security_group_ids,
    ),
  )
  vpc_id = element(distinct([for v in module.get-subnets : v.vpc.id]), 0)
}

resource "aws_ecs_cluster" "default" {
  name = var.name
  tags = merge({ "Name" = var.name }, var.tags)
}

resource "aws_launch_configuration" "default" {
  count = local.ec2 ? 1 : 0

  name_prefix   = "ecs-cluster-${var.name}"
  instance_type = var.instance_type
  key_name      = var.key_name

  image_id             = data.aws_ami.selected[0].id
  security_groups      = concat([aws_security_group.default[0].id], local.security_group_ids)
  iam_instance_profile = var.iam_instance_profile

  user_data = data.template_file.selected[0].rendered

  # Always use name_prefix with this lifecycle setting
  lifecycle {
    create_before_destroy = true
  }

  # aws ec2 describe-images --image-ids ami-04b61a4d3b11cc8ea
  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = 220 # Gigabytes
  }

  associate_public_ip_address = var.associate_public_ip_address
}

resource "aws_autoscaling_group" "default" {
  count = local.ec2 ? 1 : 0

  name_prefix = "ecs-cluster-${var.name}"

  min_size         = var.min
  max_size         = var.max
  desired_capacity = var.desired

  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.default[0].name
  vpc_zone_identifier  = local.subnet_ids

  tag {
    key                 = "Name"
    value               = "ecs-cluster-${var.name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
