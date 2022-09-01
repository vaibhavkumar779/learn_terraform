provider "aws" {
  region = var.region
}

# Dynamically get ami of public images

data "aws_ami" "ubuntu-latest" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


# Create  EC2

resource "aws_instance" "Ec2" {
  ami           = "${data.aws_ami.ubuntu-latest.id}"
  instance_type =  var.instance_type

  tags = {
           Name = var.environment_name
   }


}

