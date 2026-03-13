resource "aws_security_group" "alb" {
  name        = "alb_ecs"
  description = "security group for alb"
  vpc_id      = module.vpc.vpc_id
}
resource "aws_security_group_rule" "entrada_alb" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.alb.id  # Permitir tráfego de entrada para o ALB na porta 8000 de qualquer origem
}
resource "aws_security_group_rule" "saida_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.alb.id # Permitir tráfego de saída do ALB para a internet
}
resource "aws_security_group" "privado" { # Security group para as instâncias privadas do ECS
  name        = "privado_ecs"
  description = "security group for private instances"
  vpc_id      = module.vpc.vpc_id # Referencia o VPC criado no módulo VPC para associar o security group ao VPC correto
}
resource "aws_security_group_rule" "entrada_ecs" { # Permitir tráfego do ALB para as instâncias privadas
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.alb.id # Permitir tráfego do security group do ALB via ALB
  # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.privado.id  # Permitir tráfego do security group do ALB para as instâncias privadas
}
resource "aws_security_group_rule" "saida_ecs" { # Permitir tráfego de saída das instâncias privadas para a internet
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.privado.id  # Permitir tráfego de saída das instâncias privadas para a internet
}
