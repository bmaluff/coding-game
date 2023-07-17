resource "tls_private_key" "prod-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "prod_key_pair" {
  key_name        = "prod-ec2-keypair"
  public_key = tls_private_key.prod-ssh-key.public_key_openssh
}
