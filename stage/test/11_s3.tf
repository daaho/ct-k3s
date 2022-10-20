resource "aws_s3_bucket" "alb-logs-daaho" {
  bucket = "alb-logs-daaho"

  tags = {
    Name = "ALB logs"
  }
}

resource "aws_s3_bucket_acl" "alb-logs-daaho_acl" {
  bucket = aws_s3_bucket.alb-logs-daaho.id
  acl    = "private"
}