resource "tls_self_signed_cert" "prod_self_cert" {
  private_key_pem = tls_private_key.prod-ssh-key.private_key_pem

  subject {
    common_name  = "coding-games.com"
    organization = "coding-games, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "prod_self_cert" {
  private_key      = tls_private_key.prod-ssh-key.private_key_pem
  certificate_body = tls_self_signed_cert.prod_self_cert.cert_pem
}