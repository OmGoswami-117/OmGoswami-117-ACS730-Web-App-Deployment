variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

variable "prefix" {
  type        = string
  description = "Name prefix"
}

# custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# public subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host Webserver"
}
 
variable "env" {
  type        = string
  description = "Deployment Environment"
}
