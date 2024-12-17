provider "aws" {
  region = "us-east-2"
}
 
#S3 Bucket - stores static files for next.js website
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "akadarkoh-portfolio-bucket"
}

# Ownership Conrol - belonging totally to owner - bucket owner will now have complete control over content
resource "aws_s3_bucket_ownership_controls" "next_js_bucket_ownership_controls" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}


resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false

}

#Bucket ACL - set the access control list to public allowing everyone to read and ensures 
#the ownership controls and public access block settings are applied before setting the ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  
  depends_on = [ 
    aws_s3_bucket.next_js_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
     ]

    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
}

# Bucket Policy
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsonencode({
        version = "2012-10-17"
        statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
            }
        ]
    })
}