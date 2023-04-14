variable "associate_public_ip_address" {
  description = "Associate a public ip address with the ECS container instances"
  default     = true
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  default     = null
}

variable "efs_volume_name" {
  description = "Optional EFS volume name"
  default     = null
}

variable "enable_ec2" {
  description = "Use EC2 cluster; set to false for a Fargate cluster"
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the ECS container instances"
  default     = "ecsInstanceRole"
}

variable "ingress_security_group_ids" {
  description = "A list of security group id(s) that can directly communicate with containers"
  type        = list(string)
  default     = []
}

variable "ingress_security_group_names" {
  description = "A list of security group name(s) that can directly communicate with containers"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type for the cluster"
  default     = null
}

variable "key_name" {
  description = "Name of an AWS key pair to use for the container instances"
  default     = null
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  default     = null
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  default     = null
}

variable "name" {
  description = "The name of the Amazon ECS cluster to create"
}

variable "security_group_ids" {
  description = "A list of security group ID(s) associated with the (EC2) container instances"
  type        = list(string)
  default     = []
}

variable "security_group_names" {
  description = "A list of security group name(s) associated with the (EC2) container instances"
  type        = list(string)
  default     = []
}


variable "ssh_cidr_blocks" {
  description = "List of CIDR blocks to use for SSH access"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnet ids to use for the container instances"
  type        = list(string)
  default     = []
}

variable "subnet_type" {
  description = "Subnet type (e.g., 'campus', 'private', 'public') for resource placement"
  default     = null
}

variable "tags" {
  description = "Tags to be applied to resources where supported"
  type        = map(string)
  default     = {}
}

variable "template" {
  description = "Template used to configure underlying EC2 instances"
  default     = null
}

variable "vpc" {
  description = "VPC name"
  default     = null
}
