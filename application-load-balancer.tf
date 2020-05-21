#Step 3: Creating load balancer to forward traffic to autoscaling group
resource "aws_alb" "chat-application-load-balancer" {
  name     = "chat-application-load-balancer"
  internal = false
  subnets = [
    aws_subnet.chat-subnet-1.id,
    aws_subnet.chat-subnet-2.id
  ]
  security_groups = [
    aws_security_group.chat-security-group.id
  ]
}
#autoscaling group will be listening in port 5000 so we want to forward HTTP traffic to its port
resource "aws_alb_target_group" "chat-application-target-group" {
  name     = "chat-application-target-group"
  port     = "5000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.chat-vpc.id
  tags = {
    Name = "chat-application-target-group"
  }
  stickiness {
    type = "lb_cookie"
  }
}

#Listener will listen in port 80 and forward traffic to target group
resource "aws_alb_listener" "chat-alb-listener" {
  load_balancer_arn = aws_alb.chat-application-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.chat-application-target-group.arn
    type             = "forward"
  }

}

resource "aws_autoscaling_attachment" "chat-autoscaling-attachment" {
  alb_target_group_arn   = aws_alb_target_group.chat-application-target-group.arn
  autoscaling_group_name = aws_autoscaling_group.chat-autoscaling-group.name

}




