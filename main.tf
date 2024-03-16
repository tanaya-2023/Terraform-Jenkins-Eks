###Create VPC  [[[ From terraform documentation use an existing  module 

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-eks-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.availability-zones.names
  public_subnets = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-eks-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "Jenkins_Public_Subnet"
  }
}


### Security Group  Creation From module
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group For Jenkins-Eks-Server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Http"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Ssh"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {

      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}

### Here  Datasource is use for fetching the ami's


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

  output "image_id" {
  description = "ami"
  value       = data.aws_ami.ubuntu.image_id
}

data "aws_availability_zones" "availability-zones" {
}

### Ec2 Creation

  resource "aws_instance" "jenkins-eks-server" {
  instance_type           = var.instance_type
  ami                     = data.aws_ami.ubuntu.image_id
  key_name                = "Linux-key"
  #monitoring              = true
  vpc_security_group_ids  = [module.jenkins_sg.security_group_id]
  subnet_id               = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data               = file("${path.module}/jenkins-install.sh")
  availability_zone       = data.aws_availability_zones.availability-zones.names[0]
  tags = {
    Name        = "Jenkins-Eks-Server"
  }
}
