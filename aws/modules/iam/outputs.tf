output "task_definition_policy" {
  value = aws_iam_role_policy.task_definition_policy
}
output "task_execution_role" {
  value = aws_iam_role.task_execution_role
}
output "ecs_policy" {
  value = aws_iam_role_policy.ecs_policy
}
output "ecs_role" {
  value = aws_iam_role.ecs_role
}