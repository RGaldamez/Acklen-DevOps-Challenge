output "application_load_balancer_address" {
  value = aws_alb.chat-application-load-balancer.dns_name
}
