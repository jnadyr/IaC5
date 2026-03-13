module "ecs" {                              # Configuração do módulo ECS para criar um cluster gerenciado pela AWS
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"                        # Boa prática fixar a versão

  cluster_name = "Django-API-Cluster"       # O nome é obrigatório

  fargate_capacity_providers = {        # Configuração moderna para Fargate no módulo
    FARGATE = {
      default_capacity_provider_strategy = { # Configuração de estratégia de capacidade para Fargate
        weight = 100
      }
    }
  }
}

resource "aws_ecs_task_definition" "Django-API" {  # Definição da tarefa ECS para a aplicação Django
  family                   = "Django-API"          # O nome da família é obrigatório e deve ser único dentro da conta e região
  requires_compatibilities = ["FARGATE"]           # Especifica que a tarefa é compatível com Fargate
  network_mode             = "awsvpc"              # Recomendado para Fargate, permite atribuir uma interface de rede elástica (ENI) a cada tarefa
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.papel.arn # Recomendado para a tarefa executar ações como puxar imagens do ECR, enviar logs para CloudWatch, etc.
  # task_role_arn            = aws_iam_role.papel.arn # Recomendado para a aplicação acessar recursos AWS

  container_definitions = jsonencode([
    {
      "name"      = "producao"               # O nome do container, deve ser único dentro da tarefa
      "image"     = "545131826695.dkr.ecr.us-east-2.amazonaws.com/producao:v1"
      "cpu"       = 256
      "memory"    = 512
      "essential" = true
      "portMappings" = [
        {
          "containerPort" = 8000
          "hostPort"      = 8000
          "protocol"      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "Django-API" {
  name            = "Django-API"
  cluster         = module.ecs.cluster_id                  # Referencia o ID do cluster criado pelo módulo ECS
  task_definition = aws_ecs_task_definition.Django-API.arn # Referencia a definição da tarefa criada para a aplicação Django
  desired_count   = 3                                      # Número de instâncias da tarefa que queremos rodar    

  load_balancer {                                       # Configuração do balanceador de carga para a aplicação Django
    target_group_arn = aws_lb_target_group.alvo.arn     # Referência o target group criado para o ALB
    container_name   = "producao"                       # O nome do container definido na definição da tarefa
    container_port   = 8000
  }

  network_configuration {   # Configuração de rede para a tarefa ECS, usando o modo awsvpc recomendado para Fargate
    subnets          = module.vpc.private_subnets       # Referencia as subnets privadas do módulo VPC
    security_groups  = [aws_security_group.privado.id]  # Referencia o grupo de segurança criado para as tarefas ECS
    assign_public_ip = false                            # Como está na subnet privada, deve ser false
  }

  capacity_provider_strategy {          # Configuração moderna para Fargate no serviço ECS
    capacity_provider = "FARGATE"       # Especifica que o serviço deve usar Fargate como provedor de capacidade
    weight            = 1               # Peso para a estratégia de capacidade, útil se houver múltiplos provedores
  }
}
