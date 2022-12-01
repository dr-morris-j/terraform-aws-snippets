resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "python_lambda_package" {
  type = "zip"
  source_dir = "${path.module}/layer"
  output_path = "app.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "app.zip"
  function_name = "app"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.handler"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  runtime = "python3.9"
  timeout       = 10

}