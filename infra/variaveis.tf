variable nome_repositorio {
  type        = string
  description = "Nome do repositório ECR"
}
variable papelIAM {
  type        = string
  description = "Nome do papel (role) IAM para as instâncias ECS"
}
variable ambiente {
  type        = string
  description = "Ambiente de implantação (ex: produção, desenvolvimento)"
}
variable papel {
  type        = string
  description = "Nome do papel para o perfil IAM"
}


