####################   Data AWS

data "aws_caller_identity" "account" {}

data "aws_availability_zones" "available" {}

data "aws_s3_bucket" "output_artifact" {
  bucket = var.bucket_name_artifact
}

data "aws_codecommit_repository" "project" {
  repository_name = var.repository_name
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
data "aws_vpc" "targetVpc" {
  filter {
    name   = "tag-value"
    values = ["${var.vpc_name}"]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.targetVpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}