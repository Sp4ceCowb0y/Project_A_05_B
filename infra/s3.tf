resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-${random_string.random.result}"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "local_file" "s3-bucket" { 
  content = <<EOF
terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.terraform-state.bucket}"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
EOF
  filename = "${path.module}/backend.txt"
}