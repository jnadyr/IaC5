module "prod" {
  source = "../../infra"                  # Caminho relativo para o módulo. O infra é o source do modulo.
  
  nome_repositorio = "producao-ecr-repo"  # Nome do repositório ECR para a imagem Docker
  papelIAM = "producao"
  ambiente = "producao"
  papel = "producao"
  }
  output "IP_alb" {
    value = module.prod.IP                # Referencia o output do módulo para o DNS do ALB
  }
  