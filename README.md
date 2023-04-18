# AWS CodeBuild

## Getting started

Example

````
module "example-codebuild" {
  env                      = var.env
  project                  = local.project_name
  repository_name          = var.codecommit_repository_name
  bucket_name_artifact     = var.artifacts_bucket
  bucket_name_codepipeline = var.codepipeline_bucket
  vpc_name = "pipeline-main-vpc"
  region                   = var.region
  branch_name              = "main"

  environment_variables = [
    {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.account.account_id
      type  = "PLAINTEXT"
    },
    {
      name  = "ECR_REPOSITORY_NAME_WP"
      value = var.wp_repository_name
      type  = "PLAINTEXT"
    },
  ]
}
````

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_policy.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.codepipeline_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.codepipeline_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_security_group.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_codecommit_repository.project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/codecommit_repository) | data source |
| [aws_iam_policy_document.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.output_artifact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.targetVpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Name of Branch | `string` | n/a | yes |
| <a name="input_bucket_name_artifact"></a> [bucket\_name\_artifact](#input\_bucket\_name\_artifact) | Name of Bucket where to store files | `string` | n/a | yes |
| <a name="input_bucket_name_codepipeline"></a> [bucket\_name\_codepipeline](#input\_bucket\_name\_codepipeline) | Name of the bucket for CodePipeline | `string` | n/a | yes |
| <a name="input_compute_image"></a> [compute\_image](#input\_compute\_image) | Docker image to use for this build project | `string` | `"aws/codebuild/standard:5.0"` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | Information about the compute resources the build project will use | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>      type  = string<br>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project to deploy | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Name of Region where well be working | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of repository project | `string` | n/a | yes |
| <a name="input_sg_egress"></a> [sg\_egress](#input\_sg\_egress) | List object for create a custom SG | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_sg_ingress"></a> [sg\_ingress](#input\_sg\_ingress) | List object for create a custom SG | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_type_build_environment"></a> [type\_build\_environment](#input\_type\_build\_environment) | Type of build environment to use for related builds | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
