terraform {
  backend "s3" {
    bucket = "terraform-state-jgtna1mk"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
