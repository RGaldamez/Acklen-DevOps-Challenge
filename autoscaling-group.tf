#Step 2 CHALLENGE version: Create an autoscaling group to have dynamic instances 

#Creating the launch configuration for new instances
resource "aws_launch_configuration" "chat-autoscaling-launch-configuration" {
  name          = "chat-autoscaling-launch-configuration"
  image_id      = var.AMI
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  lifecycle {
    create_before_destroy = true
  }
  security_groups = [
    aws_security_group.chat-security-group.id
  ]
  user_data = file("run-ansible.sh")
}

resource "aws_autoscaling_group" "chat-autoscaling-group" {
  name = "chat-autoscaling-group"
  vpc_zone_identifier = [
    aws_subnet.chat-subnet-1.id,
    aws_subnet.chat-subnet-2.id
  ]
  min_size = 2
  max_size = 4
  tag {
    key                 = "Name"
    value               = "Terraform chat instance"
    propagate_at_launch = true
  }
  launch_configuration = aws_launch_configuration.chat-autoscaling-launch-configuration.name
}



#Autoscaling policy to scale up
resource "aws_autoscaling_policy" "chat-autoscaling-policy-scale-up" {
  name                   = "chat-autoscaling-policy-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.chat-autoscaling-group.name
}

resource "aws_cloudwatch_metric_alarm" "chat-cloudwatch-autoscale-alarm-up" {
  alarm_name          = "chat-cloudwatch-autoscale-alarm-up"
  alarm_description   = "Scales up when average cpu reaches 35%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "35"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.chat-autoscaling-group.name
  }


  alarm_actions = [
    aws_autoscaling_policy.chat-autoscaling-policy-scale-up.arn
  ]

}

#Autoscaling policy to scale down 
resource "aws_autoscaling_policy" "chat-autoscaling-policy-scale-down" {
  name                   = "chat-autoscaling-policy-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.chat-autoscaling-group.name
}

resource "aws_cloudwatch_metric_alarm" "chat-cloudwatch-autoscale-alarm-down" {
  alarm_name          = "chat-cloudwatch-autoscale-alarm-down"
  alarm_description   = "Scales down when average cpu reaches 15%"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "15"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.chat-autoscaling-group.name
  }

  alarm_actions = [
    aws_autoscaling_policy.chat-autoscaling-policy-scale-down.arn
  ]
}

