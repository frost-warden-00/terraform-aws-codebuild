##################  SG - CodeBuild  ##################
resource "aws_security_group" "codebuild" {
  name        = "${local.prefix}codebuild"
  description = "Security Group for ECS codebuild."
  vpc_id      = data.aws_vpc.targetVpc.id

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = merge(tomap({ "Name" = "${local.prefix}codebuild" }))
}