variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Região das maquinas criadas"
}

variable "availability_zone" {
  default     = "us-east-1a"
  type        = string
  description = "Região das maquinas criadas"
}

variable "chave_pub_aws" {
  default     = "~/.ssh/aws-key.pub"
  description = "Chave publica privada Alex"
}