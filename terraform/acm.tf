resource "aws_acm_certificate" "app" {
  domain_name       = var.app_domain
  validation_method = "DNS"
}