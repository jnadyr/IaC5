terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"        # Boa prática fixar a versão do provider para evitar quebras inesperadas
    }
  }

  required_version = ">= 1.2"   # Especifica a versão mínima do Terraform para garantir compatibilidade
}

provider "aws" {
  region = "us-east-2"          # Estados Unidos - Ohio.
}
