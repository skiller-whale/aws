resource "aws_cloudwatch_metric_alarm" "stress" {
  alarm_name          = "StressCPUOver30"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Average CPU utilization over 30%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.stress.name
  }
}
