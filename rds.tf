resource "random_password" "truefoundry_db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "rds" {
  name       = "${local.truefoundry_db_unique_name}-rds"
  subnet_ids = var.truefoundry_db_subnet_ids
  tags       = local.tags
}

resource "aws_security_group" "rds" {
  name   = "${local.truefoundry_db_unique_name}-rds"
  vpc_id = var.vpc_id
  tags   = local.tags

  ingress {
    from_port       = local.truefoundry_db_port
    to_port         = local.truefoundry_db_port
    protocol        = "tcp"
    security_groups = [var.truefoundry_db_ingress_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "truefoundry_db" {
  tags                            = local.tags
  engine                          = "postgres"
  engine_version                  = "13.4"
  allocated_storage               = var.truefoundry_db_allocated_storage
  port                            = local.truefoundry_db_port
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
  username                        = local.truefoundry_db_master_username
  identifier_prefix               = local.truefoundry_db_unique_name
  db_name                         = local.truefoundry_db_database_name
  skip_final_snapshot             = var.truefoundry_db_skip_final_snapshot
  password                        = random_password.truefoundry_db_password.result
  backup_retention_period         = 14
  instance_class                  = var.truefoundry_db_instance_class
  publicly_accessible             = var.truefoundry_db_publicly_accessible
  deletion_protection             = var.truefoundry_db_deletion_protection
  apply_immediately               = true
  storage_encrypted               = var.truefoundry_db_storage_encrypted
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
}
