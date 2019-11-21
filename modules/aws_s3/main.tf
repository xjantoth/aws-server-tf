resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "this" {
  bucket = "certification-ciu1"
  acl    = "private"

  website {
    index_document = "index.html"
    # error_document = "error.html"

  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
{
    "Id": "Policy1574249116711",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1574248994997",
            "Action": [
                "s3:PutObject"
            ],
            "Effect": "Deny",
            "Resource": "${aws_s3_bucket.this.arn}/*",
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                }
            },
            "Principal": "*"
        },
        {
            "Sid": "Stmt1574249114050",
            "Action": [
                "s3:PutObject"
            ],
            "Effect": "Deny",
            "Resource": "${aws_s3_bucket.this.arn}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            },
            "Principal": "*"
        }
    ]
}
POLICY
}


resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
{
  "Id": "Policy1574251683654",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1574251677230",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.this.arn}/*",
      "Principal": "*"
    }
  ]
}
POLICY
}