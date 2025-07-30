terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  profile = "..."
  region  = "..."
  default_tags {
    tags = {
      Managed = "terraform"
      owner   = "Alexsandro"
    }
  }
}
