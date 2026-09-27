# EC2.2: take over the VPC's default security group and remove all its rules
resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id
}

# EC2.7 (and EC2.3 for new volumes): encrypt every new EBS disk in this region
resource "aws_ebs_encryption_by_default" "main" {
  enabled = true
}

# EC2.182: EBS snapshots can't be shared publicly
resource "aws_ebs_snapshot_block_public_access" "main" {
  state = "block-all-sharing"
}

# SSM.7: SSM documents can't be shared publicly
resource "aws_ssm_service_setting" "block_public_doc_sharing" {
  setting_id    = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:servicesetting/ssm/documents/console/public-sharing-permission"
  setting_value = "Disable"
}

# IAM.7, IAM.15, IAM.16: password rules for IAM users with console passwords
resource "aws_iam_account_password_policy" "main" {
  minimum_password_length        = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  password_reuse_prevention      = 24
  allow_users_to_change_password = true
}

# IAM.28: flags any resource shared outside this account
resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "dso-account-analyzer"
  type          = "ACCOUNT"
}

# GuardDuty.1: threat detection from CloudTrail, VPC and DNS activity
resource "aws_guardduty_detector" "main" {
  enable = true
}