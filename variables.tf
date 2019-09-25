variable "name" {
  description = "The name of the Amazon ECS cluster to create"
}

variable "enable_ec2_container_instances" {
  description = "Set to false for Fargate only clusters."
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the ECS container instances"
  default     = "ecsInstanceRole"
}

variable "min" {
  description = "The minimum number of ECS container instances"
  default     = "1"
}

variable "max" {
  description = "The maximum number of container instances"
  default     = "10"
}

variable "desired" {
  description = "The desired number of container instances"
  default     = "3"
}

variable "efs_volume_name" {
  description = "Optional EFS volume name"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with the ECS container instances"
  default     = true
}

variable "instance_type" {
  description = "The EC2 instance type to use for the container instances"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an AWS key pair to use for the container instances"
  default     = ""
}

variable "vpc" {
  description = "The name of the VPC to use"
  default     = ""
}

variable "subnet_ids" {
  description = "A list of subnet ids to use for the container instances"
  default     = []
}

variable "template" {
  description = "Template used to configure underlying EC2 instances"
  default     = ""
}

variable "tier" {
  description = "Name of subnet tier (e.g., public, private, nat)"
  default     = ""
}

variable "ssh_cidr_blocks" {
  description = "List of CIDR blocks to use for SSH access"
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources that support tagging"
  default     = {}
}

variable "security_group_ids" {
  description = "A list of security group id(s) that can directly communicate with containers on the cluster"
  default     = []
}

variable "security_groups" {
  description = "A list of security group name(s) that can directly communicate with containers on the cluster"
  default     = []
}
