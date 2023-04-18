data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = "codebuild"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "codebuild2"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "codebuild3"

    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.account.account_id}:network-interface/*"
    ]

    condition {
      test     = "StringEquals"
      values   = [for subnet in data.aws_subnet.subnet : subnet.arn]
      variable = "ec2:Subnet"
    }
  }

  statement {
    sid = "codebuild4"

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      "*"
    ]
  }

  statement {
    sid = "codebuild5"

    actions = [
      "ecr:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "Secrets"

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name   = "${local.prefix}codebuild"
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

resource "aws_iam_role" "codebuild" {
  name = "${local.prefix}codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}