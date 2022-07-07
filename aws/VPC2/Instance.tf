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
resource "aws_instance" "terraform_instance1" {
  depends_on = [
    aws_security_group.allow-ssh,
    local_sensitive_file.pem_file
  ]
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "public-${var.environment_name}"
  }

  #VPC Subnet
  subnet_id = aws_subnet.public.id

  #security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  #public key
  key_name = aws_key_pair.vk.key_name

}

#Instance on private subnet
resource "aws_instance" "terraform_instance2" {
  depends_on = [
    aws_instance.terraform_instance1
  ]
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "private-${var.environment_name}"
  }

  #VPC Subnet
  subnet_id = aws_subnet.private.id

  #security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  #public key
  key_name = aws_key_pair.vk.key_name

}
