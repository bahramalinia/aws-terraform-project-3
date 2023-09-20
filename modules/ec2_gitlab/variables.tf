

variable "instance_name" {
        description = "Name of the instance to be created"
        default = "my-ec2-instance"
}

variable "instance_type" {
        default = "t2.micro"
}

variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-07ebbe60"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-09d56f8956ab235b3"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "my_terrafor init ec2"
}

variable "key_name" {
        default = "mykey"
}

# colect date  from AWS AMI 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



/*variable "tcb_blog_vpc_id" {
  default = "vpc-044a05c74d46127b6" # Orientações para copia da VPC ID abaixo.
}

variable "tcb_blog_subnet_public_id" {
  default = "subnet-0f001d93c9e954103" # Orientações para copia da Subnet ID abaixo.
}*/

variable "vpc_id" {}
variable "subnet_ids" {}

