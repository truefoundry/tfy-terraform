locals {

  mlfoundry_unique_name  = var.mlfoundry_s3_enable_override ? var.mlfoundry_s3_override_name : "tfy-mlfoundry-${var.unique_name}"
  svcfoundry_unique_name = var.svcfoundry_s3_enable_override ? var.svcfoundry_s3_override_name : "tfy-svcfoundry-${var.unique_name}"

  truefoundry_db_unique_name = var.truefoundry_db_enable_override ? var.truefoundry_db_override_name : "tfy-${var.unique_name}"

  truefoundry_db_port            = 5432
  truefoundry_db_master_username = "root"
  truefoundry_db_database_name   = "ctl"

  tags = merge(
    {
      "terraform-module" = "terraform-aws-truefoundry"
      "terraform"        = "true"
    },
    var.tags
  )
}