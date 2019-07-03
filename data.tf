data "aws_security_group" "selected" {
  count = "${local.ec2 ? length(var.security_groups) : 0}"

  name = "${var.security_groups[count.index]}"
}

data "aws_vpc" "selected" {
  count = "${local.ec2 ? 1 : 0}"

  tags {
    Name = "${var.vpc}"
  }
}

data "aws_subnet_ids" "selected" {
  count = "${local.ec2 && var.tier != "" ? 1 : 0}"

  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Tier = "${var.tier}"
  }
}

data "aws_ami" "selected" {
  count = "${local.ec2 ? 1 : 0}"

  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  owners = ["amazon"]
}

data "template_file" "selected" {
  count = "${local.ec2 ? 1 : 0}"

  template = "${local.template}"

  vars {
    ecs_cluster_name = "${var.name}"
  }
}
