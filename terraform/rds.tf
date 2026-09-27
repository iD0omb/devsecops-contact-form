# Which subnets RDS may use: the two private ones (must span 2 AZs)
resource "aws_db_subnet_group" "main" {
  name       = "dso-db-subnets"
  subnet_ids = aws_subnet.private[*].id
  tags       = { Name = "dso-db-subnets" }
}

# RDS firewall: nothing allowed in except the rule below
resource "aws_security_group" "rds" {
  name        = "dso-rds"
  description = "Postgres from EKS nodes only"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "dso-rds" }
}

# Port 5432, only from the EKS node security group
resource "aws_vpc_security_group_ingress_rule" "rds_from_nodes" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Postgres from EKS nodes"
}

resource "aws_db_instance" "main" {
  identifier     = "dso-postgres"
  engine         = "postgres"
  engine_version = "17"           # 15+ means TLS is enforced by default
  instance_class = "db.t4g.micro" # smallest 

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true # encryption at rest

  db_name                     = "contactform"
  username                    = "devsecopsDBAdmin"
  manage_master_user_password = true # RDS generates the password into Secrets Manager

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period         = 7
  copy_tags_to_snapshot           = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  apply_immediately               = true
  skip_final_snapshot             = true  # so teardown doesn't leave a snapshot
  deletion_protection             = false # so terraform destroy works
}