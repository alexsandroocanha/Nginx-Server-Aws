output "ip_ec2" {
  value       = aws_instance.webservice.public_ip
  sensitive   = false
  description = "Saida do IP Publico da Instancia EC2"
}