resource "aws_launch_template" "lt" {
  name_prefix   = "vebuin"
#   image_id      = aws_ami_from_instance.app_ami.id
  image_id      = var.instance_ami  # Replace with your AMI ID
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_id
  }

  user_data = var.user_data

}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = var.subnets_id # Replace with your subnet
  desired_capacity    = 2
  min_size           = 2
  max_size           = 4

  target_group_arns = var.target_group_arn

#   health_check_type          = "EC2"

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.id
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.id
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Scale up when CPU > 70%"
  actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale down when CPU < 50%"
  actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}