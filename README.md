# Truefoundry Terraform

This module will let you create the aws infrastructure needed to deploy Truefoundry on your cluster.

It is composed of the following main components:

- S3 buckets (mlfoundry, servicefoundry)
- RDS instance

You can use this module with:

```terraform
module "truefoundry" {
  source = "github.com/truefoundry/terraform-aws-truefoundry.git"

  unique_name = "truefoundry-${random_id.id.hex}"

  mlfoundry_s3_force_destroy  = false
  svcfoundry_s3_force_destroy = false

  truefoundry_db_allocated_storage      = "10"
  truefoundry_db_ingress_security_group = aws_security_group.insecure_sg.id
  truefoundry_db_instance_class         = "db.t3.micro"
  truefoundry_db_subnet_ids             = module.vpc.private_subnets
  vpc_id                                = "your-vpc-id"
}
```

For a more complete example check [terratest/examples/main.tf](terratest/examples/main.tf)
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.truefoundry_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.mlfoundry_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.svcfoundry_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.mlfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.svcfoundry_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds-public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.truefoundry_db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy_document.mlfoundry_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mlfoundry_bucket_tls_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.svcfoundry_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.svcfoundry_bucket_tls_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mlfoundry_artifact_buckets_will_read"></a> [mlfoundry\_artifact\_buckets\_will\_read](#input\_mlfoundry\_artifact\_buckets\_will\_read) | A list of bucket IDs mlfoundry will need read access to, in order to show the stored artifacts. It accepts any valid IAM resource, including ARNs with wildcards, so you can do something like arn:aws:s3:::bucket-prefix-* | `list(string)` | `[]` | no |
| <a name="input_mlfoundry_s3_cors_origins"></a> [mlfoundry\_s3\_cors\_origins](#input\_mlfoundry\_s3\_cors\_origins) | List of CORS origins for Mlfoundry bucket | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_mlfoundry_s3_enable_override"></a> [mlfoundry\_s3\_enable\_override](#input\_mlfoundry\_s3\_enable\_override) | Enable override for s3 bucket name. You must pass mlfoundry\_s3\_override\_name | `bool` | `false` | no |
| <a name="input_mlfoundry_s3_encryption_algorithm"></a> [mlfoundry\_s3\_encryption\_algorithm](#input\_mlfoundry\_s3\_encryption\_algorithm) | Algorithm used for encrypting the default bucket. | `string` | `"AES256"` | no |
| <a name="input_mlfoundry_s3_encryption_key_arn"></a> [mlfoundry\_s3\_encryption\_key\_arn](#input\_mlfoundry\_s3\_encryption\_key\_arn) | ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm. | `string` | `null` | no |
| <a name="input_mlfoundry_s3_force_destroy"></a> [mlfoundry\_s3\_force\_destroy](#input\_mlfoundry\_s3\_force\_destroy) | Force destroy for mlfoundry s3 bucket | `bool` | n/a | yes |
| <a name="input_mlfoundry_s3_override_name"></a> [mlfoundry\_s3\_override\_name](#input\_mlfoundry\_s3\_override\_name) | Override name for s3 bucket. mlfoundry\_s3\_enable\_override must be set true | `string` | `""` | no |
| <a name="input_svcfoundry_artifact_buckets_will_read"></a> [svcfoundry\_artifact\_buckets\_will\_read](#input\_svcfoundry\_artifact\_buckets\_will\_read) | A list of bucket IDs svcfoundry will need read access to, in order to show the stored artifacts. It accepts any valid IAM resource, including ARNs with wildcards, so you can do something like arn:aws:s3:::bucket-prefix-* | `list(string)` | `[]` | no |
| <a name="input_svcfoundry_s3_enable_override"></a> [svcfoundry\_s3\_enable\_override](#input\_svcfoundry\_s3\_enable\_override) | Enable override for s3 bucket name. You must pass svcfoundry\_s3\_override\_name | `bool` | `false` | no |
| <a name="input_svcfoundry_s3_encryption_algorithm"></a> [svcfoundry\_s3\_encryption\_algorithm](#input\_svcfoundry\_s3\_encryption\_algorithm) | Algorithm used for encrypting the default bucket. | `string` | `"AES256"` | no |
| <a name="input_svcfoundry_s3_encryption_key_arn"></a> [svcfoundry\_s3\_encryption\_key\_arn](#input\_svcfoundry\_s3\_encryption\_key\_arn) | ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm. | `string` | `null` | no |
| <a name="input_svcfoundry_s3_force_destroy"></a> [svcfoundry\_s3\_force\_destroy](#input\_svcfoundry\_s3\_force\_destroy) | Force destroy for svcfoundry s3 bucket | `bool` | n/a | yes |
| <a name="input_svcfoundry_s3_override_name"></a> [svcfoundry\_s3\_override\_name](#input\_svcfoundry\_s3\_override\_name) | Override name for s3 bucket. svcfoundry\_s3\_enable\_override must be set true | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |
| <a name="input_truefoundry_db_allocated_storage"></a> [truefoundry\_db\_allocated\_storage](#input\_truefoundry\_db\_allocated\_storage) | Storage for RDS | `string` | n/a | yes |
| <a name="input_truefoundry_db_deletion_protection"></a> [truefoundry\_db\_deletion\_protection](#input\_truefoundry\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_truefoundry_db_enable_override"></a> [truefoundry\_db\_enable\_override](#input\_truefoundry\_db\_enable\_override) | Enable override for truefoundry db name. You must pass truefoundry\_db\_override\_name | `bool` | `false` | no |
| <a name="input_truefoundry_db_ingress_security_group"></a> [truefoundry\_db\_ingress\_security\_group](#input\_truefoundry\_db\_ingress\_security\_group) | SG allowed to connect to the database | `string` | n/a | yes |
| <a name="input_truefoundry_db_instance_class"></a> [truefoundry\_db\_instance\_class](#input\_truefoundry\_db\_instance\_class) | Instance class for RDS | `string` | n/a | yes |
| <a name="input_truefoundry_db_override_name"></a> [truefoundry\_db\_override\_name](#input\_truefoundry\_db\_override\_name) | Override name for truefoundry db. truefoundry\_db\_enable\_override must be set true | `string` | `""` | no |
| <a name="input_truefoundry_db_publicly_accessible"></a> [truefoundry\_db\_publicly\_accessible](#input\_truefoundry\_db\_publicly\_accessible) | Make database publicly accessible. Subnets and SG must match | `string` | `false` | no |
| <a name="input_truefoundry_db_skip_final_snapshot"></a> [truefoundry\_db\_skip\_final\_snapshot](#input\_truefoundry\_db\_skip\_final\_snapshot) | n/a | `bool` | `false` | no |
| <a name="input_truefoundry_db_storage_encrypted"></a> [truefoundry\_db\_storage\_encrypted](#input\_truefoundry\_db\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_truefoundry_db_subnet_ids"></a> [truefoundry\_db\_subnet\_ids](#input\_truefoundry\_db\_subnet\_ids) | List of subnets where the RDS database will be deployed | `list(string)` | n/a | yes |
| <a name="input_unique_name"></a> [unique\_name](#input\_unique\_name) | Truefoundry deployment unique name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | AWS VPC to deploy Truefoundry rds | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mlfoundry_bucket_id"></a> [mlfoundry\_bucket\_id](#output\_mlfoundry\_bucket\_id) | n/a |
| <a name="output_mlfoundry_iam_role_arn"></a> [mlfoundry\_iam\_role\_arn](#output\_mlfoundry\_iam\_role\_arn) | n/a |
| <a name="output_svcfoundry_bucket_id"></a> [svcfoundry\_bucket\_id](#output\_svcfoundry\_bucket\_id) | n/a |
| <a name="output_svcfoundry_iam_role_arn"></a> [svcfoundry\_iam\_role\_arn](#output\_svcfoundry\_iam\_role\_arn) | n/a |
| <a name="output_truefoundry_db_address"></a> [truefoundry\_db\_address](#output\_truefoundry\_db\_address) | n/a |
| <a name="output_truefoundry_db_database_name"></a> [truefoundry\_db\_database\_name](#output\_truefoundry\_db\_database\_name) | n/a |
| <a name="output_truefoundry_db_endpoint"></a> [truefoundry\_db\_endpoint](#output\_truefoundry\_db\_endpoint) | n/a |
| <a name="output_truefoundry_db_engine"></a> [truefoundry\_db\_engine](#output\_truefoundry\_db\_engine) | n/a |
| <a name="output_truefoundry_db_id"></a> [truefoundry\_db\_id](#output\_truefoundry\_db\_id) | n/a |
| <a name="output_truefoundry_db_password"></a> [truefoundry\_db\_password](#output\_truefoundry\_db\_password) | n/a |
| <a name="output_truefoundry_db_port"></a> [truefoundry\_db\_port](#output\_truefoundry\_db\_port) | n/a |
| <a name="output_truefoundry_db_username"></a> [truefoundry\_db\_username](#output\_truefoundry\_db\_username) | n/a |
<!-- END_TF_DOCS -->