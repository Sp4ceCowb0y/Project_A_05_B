output "jenkins-ip" {
  value = [aws_instance.jenkins-instance.*.public_ip]
}

output "app-ip" {
  value = [aws_instance.app-instance.*.public_ip]
}

output "aws-instance-id" {
  value = aws_instance.jenkins-instance.id
}

output "s3-bucket-infra-tfstate" {
  value = aws_s3_bucket.terraform-state.bucket
}