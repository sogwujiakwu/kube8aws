resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "k8_ssh_key" {
    filename = "k8_ssh_key.pem"
    file_permission = "600"
    content  = tls_private_key.ssh.private_key_pem
}

resource "aws_key_pair" "k8_ssh" {
  key_name   = "k8_ssh"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_s3_object" "object" {
  bucket = "tfstate-bucket-20230223"
  key    = "k8_ssh_key.pem"
  source = local_file.k8_ssh_key.filename

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
}
