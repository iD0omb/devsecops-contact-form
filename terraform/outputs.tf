# RDS
output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "db_secret_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

# ECR Repository
output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

#IRSA, Output the role of the application's IAM role
output "app_role_arn" {
  value = aws_iam_role.app.arn
}

# ACM Certificate for HTTPS
output "acm_certificate_arn" {
  value = aws_acm_certificate.app.arn
}

output "acm_validation_record" {
  value = aws_acm_certificate.app.domain_validation_options
}

