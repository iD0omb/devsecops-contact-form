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

#IRSA, Output the role of the application's 
output "app_role_arn" {
  value = aws_iam_role.app.arn
}

# ACM Certificate for HTTPS
output "aws_acm_certificate_arn" {
  value = aws_acm_certificate.app.arn
}

output "acm_validation_record" {
  value = aws_acm_certificate.app.domain_validation_options
}