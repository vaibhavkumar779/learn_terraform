variable "ami" {}
variable "instance_type" {}
variable "region" {}
variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "environment_name" {}
variable "name" {
  default   = "VPC Terraform"
}
variable "key_name" {}