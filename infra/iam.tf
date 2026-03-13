resource "aws_iam_role" "papel" {
  name = "${var.papelIAM}_papel"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })

  tags = {
    tag-key = "Papel IAM para instâncias ECS"
  }
}
resource "aws_iam_role_policy" "ecs_ecr" { # Permitir acesso ao ECR para as instâncias ECS
  name = "ecs_ecr_policy"
  role = aws_iam_role.papel.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          # "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_instance_profile" "perfil" {
  name = "${var.papelIAM}_perfil"
  role = aws_iam_role.papel.name
}