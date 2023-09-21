variable "prefix" {}
variable "vpc_cidr_block" {}
variable "retention_days" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "key_name" {}

variable "namespace" {
  description = "Tag name da ssh-key"
  type        = string
}




