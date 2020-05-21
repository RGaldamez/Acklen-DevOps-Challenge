output "application load balancer address" {
  value = aws_alb.chat-application-load-balancer.dns_name
}
