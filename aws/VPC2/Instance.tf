resource "tls_private_key" "algo" {
  depends_on = [
    aws_security_group.allow-ssh
  ]
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "vk" {
  key_name   = var.key_name
  public_key = tls_private_key.algo.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  depends_on = [
    aws_security_group.allow-ssh
  ]
  filename             = "./${var.key_name}.pem"
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.algo.private_key_pem
}

#Instance on public subnet
resource "aws_instance" "terraform_public1" {
  depends_on = [
    aws_security_group.allow-ssh,
    local_sensitive_file.pem_file
  ]
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "public1-${var.environment_name}"
  }

  #VPC Subnet
  subnet_id = aws_subnet.public1.id

  #security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  #public key
  key_name = aws_key_pair.vk.key_name

  #connection establishment
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "./${var.key_name}.pem"
    host        = self.public_ip
  }

  # provisioner "remote-exec" {
  #   inline = [
  #       "sudo apt update -y",
  #       "sudo apt-cache search tomcat -y",
  #       "sudo apt install apache2",
  #   ]
  # }

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing tomcat"
  sudo apt update -y
  sudo apt install default-jdk -y
  sudo apt install tomcat9 tomcat9-admin -y
  echo "*** Completed Installing tomcat"
  EOF 

}

#Instance on private subnet
resource "aws_instance" "terraform_public2" {
  depends_on = [
    aws_instance.terraform_public1
  ]
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "public2-${var.environment_name}"
  }

  #VPC Subnet
  subnet_id = aws_subnet.public2.id

  #security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  #public key
  key_name = aws_key_pair.vk.key_name

  #connection establishment
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "./${var.key_name}.pem"
    host        = self.public_ip
  }

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing tomcat"
  sudo apt update -y
  sudo apt install default-jdk -y
  sudo apt install tomcat9 tomcat9-admin -y
  echo "*** Completed Installing tomcat"
  EOF 
}
