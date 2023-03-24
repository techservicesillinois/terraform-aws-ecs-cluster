module "get-subnets" {
  source = "github.com/techservicesillinois/terraform-aws-util//modules/get-subnets?ref=v3.0.4"

  count = var.enable_ec2 ? 1 : 0

  subnet_type = var.subnet_type
  vpc         = var.vpc
}

data "aws_security_group" "ingress" {
  count = var.enable_ec2 ? length(var.ingress_security_group_names) : 0

  name = var.ingress_security_group_names[count.index]
}

data "aws_security_group" "selected" {
  count = var.enable_ec2 ? length(var.security_group_names) : 0

  name = var.security_group_names[count.index]
}

data "aws_ami" "selected" {
  count = var.enable_ec2 ? 1 : 0

  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  owners = ["amazon"]
}

data "template_file" "selected" {
  count = var.enable_ec2 ? 1 : 0

  template = local.template

  vars = {
    ecs_cluster_name = var.name
    efs_volume_name  = var.efs_volume_name
  }
}
