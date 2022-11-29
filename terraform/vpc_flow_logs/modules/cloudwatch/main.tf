###### CLOUDWATCH CONFIG ######

### ENABLE FLOW LOG ###

resource "aws_flow_log" "example" {
  log_destination      = aws_s3_bucket.example.arn
  log_destination_type = "s3"
  traffic_type         = "REJECTED"
  vpc_id               = aws_vpc.example.id
}

# log all traffic into cloudwatch log group

resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.example.id
}

### CLOUDWATCH LOG GROUP ###

resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

###### IAM CONFIG ######

### IAM ROLE ###

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  name_prefix          = "vpc-flow-log-role-"
  assume_role_policy   = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role[0].json

}

### IAM POLICY ###

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    sid = "AWSVPCFlowLogsAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  role       = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  name_prefix = "vpc-flow-log-to-cloudwatch-"
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch[0].json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

###### S3 BUCKET CONFIG ######

resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "bucket_bucket" {
  bucket = "${local.bucket_name}-${random_pet.this.id}"

  tags = {
    Name        = "${local.bucket_name}-${random_pet.this.id}"
    Environment = var.environment
  }
}