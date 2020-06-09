data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins-securitygroup.id]

  # the public SSH key
  key_name = aws_key_pair.keypair.key_name

  # iam instance profile
  iam_instance_profile = aws_iam_instance_profile.jenkins-role.name
}

resource "local_file" "aws-instance-id" { 
  content = <<EOF
  variable "INSTANCE_ID" {
    default = "${aws_instance.jenkins-instance.id}"
  }
  variable "jenkins-ip" {
    default = "${aws_instance.jenkins-instance.public_ip}"
  }
  EOF
  filename = "${path.module}/../ebs_attach/instance_vars.tf"
}

resource "local_file" "ssh" { 
  content = <<EOF
    ssh -i key ubuntu@${aws_instance.jenkins-instance.public_ip}
  EOF
  filename = "${path.module}/../ssh-jenkins.sh"
}

resource "aws_instance" "app-instance" {
  count         = var.APP_INSTANCE_COUNT
  ami           = var.APP_INSTANCE_AMI
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.app-securitygroup.id]

  # the public SSH key
  key_name = aws_key_pair.keypair.key_name
}