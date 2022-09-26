output "lti_task_definition" {
  value = aws_ecs_task_definition.ecs
}
output "lti_service" {
  value = aws_ecs_service.service
}