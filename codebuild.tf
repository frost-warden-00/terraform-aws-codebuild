resource "aws_codebuild_project" "codebuild" {
  name          = "${local.prefix}codebuild"
  description   = "${local.prefix}codebuild"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type      = "S3"
    packaging = "ZIP"
    name      = "${local.prefix}code"
    location  = data.aws_s3_bucket.output_artifact.bucket
  }


  source {
    type            = "CODECOMMIT"
    location        = data.aws_codecommit_repository.project.clone_url_http
    git_clone_depth = 1
    buildspec       = ".codebuild/buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "refs/heads/${var.branch_name}"

  environment {
    compute_type                = var.compute_type
    image                       = var.compute_image
    type                        = var.type_build_environment
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  vpc_config {
    vpc_id = data.aws_vpc.targetVpc.id

    subnets = data.aws_subnets.this.ids

    security_group_ids = [
      aws_security_group.codebuild.id
    ]
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = var.bucket_name_codepipeline
  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}