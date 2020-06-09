resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = var.EBS_VOLUME_ID
  instance_id  = var.INSTANCE_ID
  skip_destroy = false
}

resource "null_resource" "configure-ebs-volume" {
  connection {
    host     = var.jenkins-ip
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
  provisioner "file" {
    source = "${path.module}/scripts/jenkins-init.sh"
    destination = "/tmp/jenkins-init.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/jenkins-init.sh",
      "export DEVICE=${var.INSTANCE_DEVICE_NAME}",
      "export JENKINS_VERSION=${var.JENKINS_VERSION}",
      "export TERRAFORM_VERSION=${var.TERRAFORM_VERSION}",
      "sudo -E bash /tmp/jenkins-init.sh > /tmp/jenkins-init.log"
    ]    
  }
}