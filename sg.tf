# http://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html

locals {
  ingress_sg_ids = toset(
    concat(
      data.aws_security_group.ingress.*.id,
      var.ingress_security_group_ids,
    )
  )
}

resource "aws_security_group" "default" {
  count = var.enable_ec2 ? 1 : 0

  # TODO: Make this user-selectable with this description as default.
  description = "ECS container instance security group for ${var.name} cluster"
  name_prefix = local.name_prefix
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_security_group_rule" "allow_icmp" {
  count = var.enable_ec2 ? 1 : 0

  type      = "ingress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "allow_all_egress" {
  count = var.enable_ec2 ? 1 : 0

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "allow_ssh" {
  count     = var.enable_ec2 && length(var.ssh_cidr_blocks) > 0 ? 1 : 0
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks       = var.ssh_cidr_blocks
  security_group_id = aws_security_group.default[0].id
}

# Add rules to default cluster security group to allow inbound
# traffic from user-supplied security groups to containers.
#
# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html

resource "aws_security_group_rule" "allow_ingress" {
  for_each = var.enable_ec2 ? local.ingress_sg_ids : toset([])

  type      = "ingress"
  from_port = 1024
  to_port   = 65535
  protocol  = "tcp"

  source_security_group_id = each.key
  security_group_id        = aws_security_group.default[0].id
}

# Add rules to user supplied security groups to allow outbound traffic
# from containers.
#
# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html

resource "aws_security_group_rule" "allow_egress" {
  for_each = var.enable_ec2 ? local.ingress_sg_ids : toset([])

  type      = "egress"
  from_port = 1024
  to_port   = 65535
  protocol  = "tcp"

  source_security_group_id = aws_security_group.default[0].id
  security_group_id        = each.key
}
