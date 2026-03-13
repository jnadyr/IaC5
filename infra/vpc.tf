module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"  # Isso garante que ele use a versão 5.x mais recente, evitando a 6.0

  name = "vpc-ecs"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]      # Especifica as zonas de disponibilidade
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]   # Subnets privadas para os serviços ECS
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # Subnets públicas para o ALB

  enable_nat_gateway = true             # Habilita o NAT Gateway para permitir que as instâncias em subnets privadas acessem a internet
 # enable_vpn_gateway = true            # Habilita o VPN Gateway para conexões VPN, se necessário  

  tags = {
    Terraform = "true"                  # Marca os recursos criados por Terraform
    Environment = "prod"                # Marca o ambiente como produção
  }
}