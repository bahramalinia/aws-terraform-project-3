terraform {
  required_version = ">=1.5.4"
  required_providers {
    aws   = ">= 5.11.0"
    local = ">=2.4.0"
  }
  backend "s3" {
    bucket = "my-bucket-pizzaria"
    key    = "terraform-pipeline.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


module "new-vpc" {
  source         = "./modules/new_vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}


module "aws_key_pair" {
  source    = "./modules/aws_key_pair"
  namespace = var.namespace

  depends_on = [
    module.new-vpc
  ]
}

module "ec2_docker" {
  source     = "./modules/ec2_docker"
  vpc_id     = module.new-vpc.vpc_id
  subnet_ids = module.new-vpc.subnet_ids
  key_name   = module.aws_key_pair.key_name
  depends_on = [
    module.new-vpc
  ]
   
}
/*
module "ec2_gitlab" {
  source     = "./modules/ec2_gitlab"
  vpc_id     = module.new-vpc.vpc_id
  subnet_ids = module.new-vpc.subnet_ids
  key_name   = module.aws_key_pair.key_name
 
    depends_on = [
    module.new-vpc
  ]
}
*/

module "ec2_jenkins" {
  source     = "./modules/ec2_jenkins"
  vpc_id     = module.new-vpc.vpc_id
  subnet_ids = module.new-vpc.subnet_ids
  key_name   = module.aws_key_pair.key_name
    depends_on = [
    module.new-vpc
  ]
  
}

module "ec2_sonarquber" {
  source     = "./modules/ec2_sonarquber"
  vpc_id     = module.new-vpc.vpc_id
  subnet_ids = module.new-vpc.subnet_ids
  key_name   = module.aws_key_pair.key_name
    depends_on = [
    module.new-vpc
  ]
}



