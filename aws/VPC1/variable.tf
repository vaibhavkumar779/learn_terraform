variable "region" {}
variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}

variable "name" {
  default   = "VPC Terraform"
}