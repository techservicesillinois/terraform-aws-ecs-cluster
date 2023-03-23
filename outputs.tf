output "name" {
  value = aws_ecs_cluster.default.name
}

output "id" {
  value = aws_ecs_cluster.default.id
}

output "security_group_name" {
  value = (local.ec2) ? aws_security_group.default.*.name : null
}

output "security_group_id" {
  value = (local.ec2) ? aws_security_group.default.*.id : null
}
