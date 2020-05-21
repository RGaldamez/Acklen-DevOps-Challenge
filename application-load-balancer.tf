#Step 3: Creating load balancer to forward traffic to autoscaling group
resource "aws_alb" "chat-application-load-balancer" {
    name="chat-application-load-balancer"
    internal = false
    subnets = [
        aws_subnet.chat-subnet-1.id,
        aws_subnet.chat-subnet-2.id
    ]
    security_groups = [
        aws_security_group.chat-security-group.id
    ]
  
}
