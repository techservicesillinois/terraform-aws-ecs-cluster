# ecs-cluster

[![Terraform actions status](https://github.com/techservicesillinois/terraform-aws-ecs-cluster/workflows/terraform/badge.svg)](https://github.com/techservicesillinois/terraform-aws-ecs-cluster/actions)

Provides an ECS cluster, and optionally EC2 container instances.

Example Usage
-----------------

### Fargate cluster

```hcl
module "fargate-cluster" {
  source = "git@github.com:techservicesillinois/terraform-aws-ecs-cluster"

  name       = "fargate-example"
  enable_ec2 = false
}
```
### EC2 cluster

```hcl
module "ecs-cluster" {
  source = "git@github.com:techservicesillinois/terraform-aws-ecs-cluster"

  name             = "ec2-example"
  desired_capacity = 1
  instance_type    = "t4g.small"
  max_size         = 4
  min_size         = 1


  # Include security groups for each ALB forwarding to this cluster.
  vpc                  = "my-vpc"
  subnet_type          = "private"
  security_group_names = ["my-vpc-alb-private", "my-vpc-alb-public"]
}
```

Argument Reference
-----------------

The following arguments are supported:

* `associate_public_ip_address` - (Optional) Associate a public IP
  address with the ECS container instances. (The default is `true`).

* `desired_capacity` - (Optional) Desired number of EC2 instances.
  Applies only to EC2 clusters.

* `efs_volume_name` - (Optional) EFS volume name. Applies only to EC2 clusters.

* `enable_ec2` - (Optional) Set to `false` to manage a Fargate cluster.
Default is `true`, which means the cluster will consist of
dedicated EC2 instances.

* `iam_instance_profile` - (Optional) The IAM instance profile to
   associate with the ECS container instances. The default is
   `ecsInstanceRole`). Applies only to EC2 clusters.

* `ingress_security_group_ids` - (Optional) A list of security group
  id(s) that can directly communicate with containers. Applies only to EC2 clusters.

* `ingress_security_group_names` - (Optional) A list of security group
  name(s) that can directly communicate with containers. Applies only to EC2 clusters.

* `instance_type` - (Optional) The EC2 instance type to use for the
  container instances. Applies only to EC2 clusters.

* `key_name` - (Optional) Name of an AWS key pair to use for the
  container instances. Applies only to EC2 clusters.

* `min_size` - (Optional) Minimum number of EC2 instances.
  Applies only to EC2 clusters.

* `max_size` - (Optional) Maximum number of EC2 instances.
  Applies only to EC2 clusters.

* `name` - (Required) The name of the Amazon ECS cluster to create.

* `security_group_ids` - (Optional) A list of security group ID(s).
Applies only to EC2 clusters.

* `security_group_names` - (Optional) A list of security group name(s)
  associated with the EC2 container instances. Applies only to EC2 clusters.

* `ssh_cidr_blocks` - (Optional) List of CIDR blocks to use for SSH
  access. Applies only to EC2 clusters.

* `subnet_ids` - (Optional) A list of subnet ids to use for the
  container instances. Applies only to EC2 clusters.

* `subnet_type` - (Optional) Subnet type (e.g., 'campus', 'private', 'public') for resource placement. Applies only to EC2 clusters.

* `tags` - (Optional) Tags to be applied to resources where supported.
 
* `template` - (Optional) Template used to configure underlying EC2
  instances. Applies only to EC2 clusters.

* `vpc` - (Optional) The name of the VPC in which to place the cluster.
Applies only to EC2 clusters.

`setting`
-------

A `setting` block is a list of maps, each map containing a name and value pair
describing cluster settings to be applied. The `setting` block is optional.

Currently, only one setting is supported.

* `name` - (Required) The setting name.

* `value` – (Optional) The setting value corresponding to `name`.

Currently, the only value allowed for `name` is `containerInsights`. The
corresponding `value` in the map must be either `enabled` or `disabled`.

```
  setting = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]
```

Attributes Reference
--------------------

The following attributes are exported:

* `id` - The Amazon Resource Name (ARN) of the cluster.

* `name` - The cluster name.

* `security_groups` - A map whose keys are the security group name, and whose values are the corresponding security group ID. Applies only to EC2 clusters. 

* `setting` – A map containing each of the defined `setting` name/value pairs.
