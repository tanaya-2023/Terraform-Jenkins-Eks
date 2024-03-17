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

###Private Subnets
variable "private_subnets" {
  type        = list(string)
  description = " Public Subnet Ranges"
}
