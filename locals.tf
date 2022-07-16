locals {
  mlfoundry_unique_name  = "tfy-mlfoundry-${var.unique_name}"
  svcfoundry_unique_name = "tfy-svcfoundry-${var.unique_name}"

  truefoundry_db_unique_name = "tfy-${var.unique_name}"

  truefoundry_db_port            = 5432
  truefoundry_db_master_username = "root"
  truefoundry_db_database_name   = "ctl"

  #  mlfoundry_db_name  = "mlfoundry"
  #  svcfoundry_db_name = "svcfoundry"
  #  mlmonitoring_db_name  = "mlmonitoring"

  tags = merge(
    {
      "terraform-module" = "terraform-aws-truefoundry"
      "terraform"        = "true"
    },
    var.tags
  )
}