output "security_group_name" {
  value = "${aws_security_group.default.*.name}"
}

output "security_group_id" {
  value = "${aws_security_group.default.*.id}"
}

output "name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "id" {
  value = "${aws_ecs_cluster.default.id}"
}
