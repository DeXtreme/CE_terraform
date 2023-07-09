# Terraform script to 
# provision an s3 bucket and
# create an IAM user with rw access


provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "azubi_bucket" {
	bucket = "ce-azubi-bucket-99"
}

resource "aws_iam_user" "bucket_user" {
	name = "bucket_user"
}

data "aws_iam_policy_document" "bucket_rw" {
	statement {
		effect = "Allow"
		actions = ["s3:ListBucket"]
		resources = ["${aws_s3_bucket.azubi_bucket.arn}"]
	}
	statement {
		effect = "Allow"
		actions = ["s3:*Object"]
		resources = ["${aws_s3_bucket.azubi_bucket.arn}"]
	}
}

resource "aws_iam_user_policy" "bucket_rw" {
	user = aws_iam_user.bucket_user.name
	policy = data.aws_iam_policy_document.bucket_rw.json
}
