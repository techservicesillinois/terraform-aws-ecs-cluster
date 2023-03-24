output "arn" {
  value = aws_ecs_cluster.default.arn
}

output "name" {
  value = aws_ecs_cluster.default.name
}

output "security_groups" {
  value = { for sg in aws_security_group.default : (sg.name) => sg.id }
}
