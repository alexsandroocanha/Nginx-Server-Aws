resource "aws_sns_topic" "alarms_topic" {
  name = "EC2-Alarms-Topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarms_topic.arn
  protocol  = "email"
  
  endpoint  = var.email_usuario
}

resource "aws_cloudwatch_metric_alarm" "instance_status_alarm" {
  alarm_name          = "Alarme-Status-Instancia-WebService"
  alarm_description   = "Alarme dispara quando a instância WebService falha na verificação de status."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2" 
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60" 
  statistic           = "Maximum"
  threshold           = "0" 

  dimensions = {
    InstanceId = aws_instance.webservice.id
  }
  alarm_actions = [aws_sns_topic.alarms_topic.arn]
  ok_actions = [aws_sns_topic.alarms_topic.arn]

}