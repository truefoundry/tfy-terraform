variable "unique_name" {
  description = "Truefoundry deployment unique name"
  type        = string
}

#variable "aws_region" {
#  description = "EKS Cluster region"
#  type        = string
#}
#
#variable "aws_account_id" {
#  description = "AWS Account ID"
#  type        = string
#}
#
#variable "account_name" {
#  description = "AWS Account Name"
#  type        = string
#}
#
#variable "cluster_oidc_issuer_url" {
#  description = "The oidc url of the eks cluster"
#  type        = string
#}
#
variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC to deploy Truefoundry rds"
}

#variable "tier" {
#  description = "Environment tier (develop|production)"
#  type        = string
#
#  validation {
#    condition     = can(regex("^develop$|^production$", var.tier))
#    error_message = "Error: Tier is not valid."
#  }
#}
#
#variable "tenant" {
#  description = "Tenant name"
#  type        = string
#}
#
#### Control Plane Components Database (truefoundry_db)

variable "truefoundry_db_ingress_security_group" {
  type        = string
  description = "SG allowed to connect to the database"
}

variable "truefoundry_db_subnet_ids" {
  type        = list(string)
  description = "List of subnets where the RDS database will be deployed"
}

variable "truefoundry_db_instance_class" {
  type        = string
  description = "Instance class for RDS"
}

variable "truefoundry_db_publicly_accessible" {
  type        = string
  default     = false
  description = "Make database publicly accessible. Subnets and SG must match"
}

variable "truefoundry_db_allocated_storage" {
  type        = string
  description = "Storage for RDS"
}

variable "truefoundry_db_skip_final_snapshot" {
  type    = bool
  default = false
}

variable "truefoundry_db_deletion_protection" {
  type    = bool
  default = true
}

variable "truefoundry_db_storage_encrypted" {
  type    = bool
  default = true
}

variable "truefoundry_db_enable_override" {
  description = "Enable override for truefoundry db name. You must pass truefoundry_db_override_name"
  type        = bool
  default     = false
}
variable "truefoundry_db_override_name" {
  description = "Override name for truefoundry db. truefoundry_db_enable_override must be set true"
  type        = string
  default     = ""
}

##### MLFoundry

variable "mlfoundry_s3_enable_override" {
  description = "Enable override for s3 bucket name. You must pass mlfoundry_s3_override_name"
  type        = bool
  default     = false
}
variable "mlfoundry_s3_override_name" {
  description = "Override name for s3 bucket. mlfoundry_s3_enable_override must be set true"
  type        = string
  default     = ""
}

variable "mlfoundry_artifact_buckets_will_read" {
  description = "A list of bucket IDs mlfoundry will need read access to, in order to show the stored artifacts. It accepts any valid IAM resource, including ARNs with wildcards, so you can do something like arn:aws:s3:::bucket-prefix-*"
  type        = list(string)
  default     = []
}

variable "mlfoundry_s3_encryption_algorithm" {
  description = "Algorithm used for encrypting the default bucket."
  type        = string
  default     = "AES256"
}

variable "mlfoundry_s3_force_destroy" {
  description = "Force destroy for mlfoundry s3 bucket"
  type        = bool
}

variable "mlfoundry_s3_encryption_key_arn" {
  description = "ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm."
  type        = string
  default     = null
}

variable "mlfoundry_s3_cors_origins" {
  description = "List of CORS origins for Mlfoundry bucket"
  type        = list(string)
  default     = ["*"]
}
###### svcfoundry

variable "svcfoundry_s3_enable_override" {
  description = "Enable override for s3 bucket name. You must pass svcfoundry_s3_override_name"
  type        = bool
  default     = false
}
variable "svcfoundry_s3_override_name" {
  description = "Override name for s3 bucket. svcfoundry_s3_enable_override must be set true"
  type        = string
  default     = ""
}

variable "svcfoundry_artifact_buckets_will_read" {
  description = "A list of bucket IDs svcfoundry will need read access to, in order to show the stored artifacts. It accepts any valid IAM resource, including ARNs with wildcards, so you can do something like arn:aws:s3:::bucket-prefix-*"
  type        = list(string)
  default     = []
}

variable "svcfoundry_s3_force_destroy" {
  description = "Force destroy for svcfoundry s3 bucket"
  type        = bool
}

variable "svcfoundry_s3_encryption_algorithm" {
  description = "Algorithm used for encrypting the default bucket."
  type        = string
  default     = "AES256"
}

variable "svcfoundry_s3_encryption_key_arn" {
  description = "ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm."
  type        = string
  default     = null
}