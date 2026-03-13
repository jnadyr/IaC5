resource "aws_lb" "alb" {   # Cria um Application Load Balancer (ALB) para distribuir o tráfego para as instâncias do ECS
  name               = "ecs-Django"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id] # Associa o security group criado para o ALB
  subnets            = module.vpc.public_subnets # public_subnets referencia as redes publicas do módulo VPC
 # enable_deletion_protection = false
}

resource "aws_lb_listener" "http" { # Cria um listener para o ALB na porta 8000 usando o protocolo HTTP
  load_balancer_arn = aws_lb.alb.arn  # Referencia o ALB criado para associar o listener ao ALB correto
  port              = "8000"
  protocol          = "HTTP"
 # ssl_policy        = "ELBSecurityPolicy-2016-08"
 # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alvo.arn # Referencia o target group criado para o ALB
  }
}
resource "aws_lb_target_group" "alvo" { # Cria um target group para o ALB, que define os destinos para os quais o ALB irá encaminhar o tráfego
  name        = "ecs-Django"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"  # Define o tipo de destino como "ip" para usar endereços IP das instâncias do ECS como destinos
  vpc_id      = module.vpc.vpc_id # Referencia o VPC criado no módulo VPC para associar o target group ao VPC correto
}

output "IP" {
  value       = aws_lb.alb.dns_name # Referencia o ALB criado para obter o DNS do ALB, que pode ser usado para acessar a aplicação
  description = "DNS do ALB"
  }

