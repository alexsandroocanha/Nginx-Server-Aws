variable "availability_zone" {
  default     = "us-east-1a"
  type        = string
  description = "Região das maquinas criadas"
}

variable "chave_pub_aws" {
  default     = "~/.ssh/..."
  description = "Chave publica privada Alex"
}

variable "email_usuario" {
  default = "email@user.com"
  description = "Email de notificação do Cloud Watch"
}