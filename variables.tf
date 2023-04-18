##################  Variables  ##################

variable "region" {
  type        = string
  description = "Name of Region where well be working"
}

variable "project" {
  type        = string
  description = "Name of the project to deploy"
}

variable "env" {
  type        = string
  description = "Name of the environment"
}

variable "repository_name" {
  type        = string
  description = "Name of repository project"
}

variable "bucket_name_artifact" {
  type        = string
  description = "Name of Bucket where to store files"
}

variable "branch_name" {
  type        = string
  description = "Name of Branch"
}

variable "bucket_name_codepipeline" {
  type        = string
  description = "Name of the bucket for CodePipeline"
}

variable "sg_ingress" {
  description = "List object for create a custom SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "sg_egress" {
  description = "List object for create a custom SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
  }))

  default     = []
  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
}

variable "compute_type" {
  default     = "BUILD_GENERAL1_SMALL"
  description = "Information about the compute resources the build project will use"
  type        = string
  validation {
    condition     = var.compute_type == "BUILD_GENERAL1_SMALL" || var.compute_type == "BUILD_GENERAL1_MEDIUM" || var.compute_type == "BUILD_GENERAL1_LARGE" || var.compute_type == "BUILD_GENERAL1_2XLARGE"
    error_message = "Compute type must be BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE or BUILD_GENERAL1_2XLARGE."
  }
}

variable "compute_image" {
  default     = "aws/codebuild/standard:5.0"
  description = "Docker image to use for this build project"
  type        = string
}

variable "type_build_environment" {
  default     = "LINUX_CONTAINER"
  description = "Type of build environment to use for related builds"
  type        = string
  validation {
    condition     = contains(["LINUX_CONTAINER", "LINUX_GPU_CONTAINER", "WINDOWS_SERVER_2019_CONTAINER", "ARM_CONTAINER"], var.type_build_environment)
    error_message = "The type build environment must be LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER."
  }
}