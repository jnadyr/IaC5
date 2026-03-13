resource "aws_ecr_repository" "repositorio" { # Recurso para criar um repositório ECR
  name                 = var.nome_repositorio # Nome do repositório, definido na variável nome_repositorio
  image_tag_mutability = "MUTABLE"            # Permite que as tags das imagens sejam mutáveis
}