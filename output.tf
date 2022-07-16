output "truefoundry_db_id" {
  value = aws_db_instance.truefoundry_db.id
}

output "truefoundry_db_endpoint" {
  value = aws_db_instance.truefoundry_db.endpoint
}

output "truefoundry_db_address" {
  value = aws_db_instance.truefoundry_db.address
}

output "truefoundry_db_port" {
  value = aws_db_instance.truefoundry_db.port
}

output "truefoundry_db_database_name" {
  value = aws_db_instance.truefoundry_db.name
}

output "truefoundry_db_engine" {
  value = aws_db_instance.truefoundry_db.engine
}

output "svcfoundry_bucket_id" {
  value = aws_s3_bucket.svcfoundry_bucket.id
}

output "mlfoundry_bucket_id" {
  value = aws_s3_bucket.mlfoundry_bucket.id
}
#
#output "mlfoundry_iam_role_arn" {
#  value = module.mlfoundry_oidc_iam.iam_role_arn
#}
#
#output "svcfoundry_iam_role_arn" {
#  value = module.svcfoundry_oidc_iam.iam_role_arn
#}
#
#output "mlmonitoring_iam_role_arn" {
#  value = module.mlmonitoring_oidc_iam.iam_role_arn
#}