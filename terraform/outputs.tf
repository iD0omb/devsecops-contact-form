# RDS
output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "db_secret_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
}

# ECR Repository
output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}