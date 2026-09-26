locals {
  app_namespace       = "contact-form"
  app_service_account = "contact-form-app"
}

# Who may use this role: only one service account in one namespace
data "aws_iam_policy_document" "app_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated" # External trusted source
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:${local.app_namespace}:${local.app_service_account}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "dso-contact-form-app"
  assume_role_policy = data.aws_iam_policy_document.app_trust.json
}

# Permissions to read the RDS-managed master database password from Secrets Manager
data "aws_iam_policy_document" "app_permissions" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_db_instance.main.master_user_secret[0].secret_arn]
  }
}

resource "aws_iam_role_policy" "app" {
  name   = "read-db-secret"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app_permissions.json
}