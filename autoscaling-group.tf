#Step 2 CHALLENGE version: Create an autoscaling group to have dynamic instances 
resource "aws_autoscaling_group" "chat-autoscaling-group" {
    name = "chat-autoscaling-group"
    vpc_zone_identifier = [
        aws_subnet.chat-subnet-1.id,
        aws_subnet.chat-subnet-2.id
    ]
    min_size = 2
    max_size = 4
    tag { 
        key = "Name"
        value = "Terraform chat instance"
        propagate_at_launch = true
    }  
}

resource "aws_launch_configuration" "chat-autoscaling-launch-configuration" {
  name = "chat-autoscaling-launch-configuration"
  image_id = var.AMI
  instance_type = var.INSTANCE_TYPE
  key_name = var.KEY_NAME
  lifecycle { 
      create_before_destroy = true
  }
  security_groups = [
      aws_security_group.chat-security-group.id
  ]
}

