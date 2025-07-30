terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  profile = "Alexsandro"
  region  = "us-east-1"
  default_tags {
    tags = {
      Managed = "terraform"
      owner   = "Alexsandro"
    }
  }
}
