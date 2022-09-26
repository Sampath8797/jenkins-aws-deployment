output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
output "app_sg" {
  value = aws_security_group.app_sg.id
}
output "rds_sg" {
  value = aws_security_group.rds_sg.id
}
