##Create variables for vpc 

variable "vpc_cidr" {
  type        = string
  description = "Vpc Cidr block"
}


## Public subnet

variable "public_subnets" {
  type        = list(string)
  description = " Public Subnet Ranges"
}

### Variable For Ec2

variable "instance_type" {
  type = string
}

variable "image_name" {
  type = string
}
