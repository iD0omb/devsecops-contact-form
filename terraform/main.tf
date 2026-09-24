data "aws_caller_identity" "current" {}

output "whoami" {
  value = data.aws_caller_identity.current.arn
}