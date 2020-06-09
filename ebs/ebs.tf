resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "jenkins-data"
  }
}

resource "local_file" "ebs-volume-id" { 
  content = <<EOF
  variable "EBS_VOLUME_ID" { 
    default = "${aws_ebs_volume.jenkins-data.id}" 
  }
  EOF
  filename = "${path.module}/../ebs_attach/ebs_volume_id.tf"
}