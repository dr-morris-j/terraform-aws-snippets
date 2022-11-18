# By the courtesy of Patrick.

resource "random_pet" "this" {
  length = 3
}

#### S3 BUCKET ####

resource "aws_s3_bucket" "audio_files" {
  bucket = "audio-files-${random_pet.this.id}"
}

resource "aws_s3_bucket_notification" "notify" {

  bucket = aws_s3_bucket.audio_files.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".mp3"
  }
}

#### LAMBDA ####

resource "aws_lambda_function" "processor" {
  function_name = "audio_processor"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.9"
  filename      = "audio-process.zip"
  handler       = "audio.lambda_handler"
}

resource "aws_lambda_permission" "s3_permission" {

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.audio_files.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.audio_files.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    effect = "Allow"
    actions = [
    "transcribe:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::*transcribe*"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-transcribe-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_transcribe_policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}