resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "AllowCloudFrontServicePrincipal",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${var.bucket_name}/*",
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : "${var.cf_distribution_arn}"
            }
          }
        }
      ]
    }
  )
}