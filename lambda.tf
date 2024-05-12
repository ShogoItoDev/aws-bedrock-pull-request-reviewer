# Create an IAM Role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-codecommit-review-${var.system_identifier}"

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

# Create an IAM policy for CodeCommit and Bedrock access
resource "aws_iam_policy" "lambda_access_policy" {
  name = "lambda-codecommit-bedrock-access-${var.system_identifier}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:GetPullRequest",
        "codecommit:PostCommentForPullRequest"
      ],
      "Resource": [
        "${aws_codecommit_repository.main.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel"
      ],
      "Resource": "*" 
    }
  ]
}
EOF
}

# Attach the policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_access_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_access_policy.arn
}

# Attach the AWSLambdaBasicExecutionRole policy to the role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create an archive of the Lambda function code
data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "lambda_function_source"
  output_path = "lambda_function.zip"
}

# Create a Lambda function
resource "aws_lambda_function" "codecommit_review" {
  function_name = "codecommit-review-${var.system_identifier}"
  handler       = "ReviewPullRequest.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn

  # (Optional) Set memory and timeout based on your needs
  memory_size = 128
  timeout     = 30

  # Use the archive file as the code source
  filename = data.archive_file.lambda_code.output_path

  source_code_hash = data.archive_file.lambda_code.output_base64sha256
}

