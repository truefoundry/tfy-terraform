terraform {
  required_version = "~>1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.8"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "random_id" "id" {
  byte_length = 4
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = "truefoundry-${random_id.id.hex}"
  cidr = "10.1.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

  enable_nat_gateway = false


  tags = {
    "owner"     = "terratest"
    "terraform" = "true"
  }
}

resource "aws_security_group" "insecure_sg" {
  name   = "truefoundry-${random_id.id.hex}-insecure-pgsql"
  vpc_id = module.vpc.vpc_id
  tags = {
    "owner"     = "terratest"
    "terraform" = "true"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "truefoundry" {
  source = "../.."

  unique_name = "truefoundry-${random_id.id.hex}"
  tags = {
    "owner"     = "terratest"
    "terraform" = "true"
  }
  mlfoundry_s3_force_destroy  = false
  svcfoundry_s3_force_destroy = false

  truefoundry_db_allocated_storage      = "10"
  truefoundry_db_ingress_security_group = aws_security_group.insecure_sg.id
  truefoundry_db_instance_class         = "db.t3.micro"
  truefoundry_db_subnet_ids             = module.vpc.private_subnets
  truefoundry_db_skip_final_snapshot    = true  // This is necessary for the tests, do do it in prod!
  truefoundry_db_deletion_protection    = false // This is necessary for the tests, do do it in prod!
  vpc_id                                = module.vpc.vpc_id
}


# Propagate outputs for terratest
output "mlfoundry_bucket_id" {
  value = module.truefoundry.mlfoundry_bucket_id
}

output "svcfoundry_bucket_id" {
  value = module.truefoundry.svcfoundry_bucket_id
}

output "truefoundry_db_id" {
  value = module.truefoundry.truefoundry_db_id
}