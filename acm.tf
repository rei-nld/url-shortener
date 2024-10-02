resource "aws_acm_certificate" "cert" {
  domain_name       = "sho.rten.me"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certValidation" {
  certificate_arn = aws_acm_certificate.cert.arn
}