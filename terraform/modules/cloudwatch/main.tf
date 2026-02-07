resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.retention_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.this.name
}

# IAM role for Fluent Bit to push logs
resource "aws_iam_role" "fluentbit_role" {
  name               = "${var.prefix}-fluentbit-role"
  assume_role_policy = data.aws_iam_policy_document.fluentbit_assume.json
}

data "aws_iam_policy_document" "fluentbit_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "fluentbit_policy" {
  name   = "${var.prefix}-fluentbit-policy"
  role   = aws_iam_role.fluentbit_role.id
  policy = data.aws_iam_policy_document.fluentbit_policy.json
}

data "aws_iam_policy_document" "fluentbit_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}

