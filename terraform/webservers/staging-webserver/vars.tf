# Instance type
variable "instance_type" {
  default     = "t3.small"
  description = "Type of the instance"
  type        = string
}

# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  type        = string
  description = "Development Environment"
}

#Private Ip of the Admin
variable "my_private_ip" {
  default     = "172.31.15.241"
  type        = string
  description = "Private IP of the Admin"
}

#Public Ip of the Admin
variable "my_public_ip" {
  default     = "3.238.15.149"
  type        = string
  description = "Public IP of the Admin"
}


variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 4
}

variable "desired_capacity" {
  default = 3
}

variable "path_to_linux_key" {
  default     = "/home/ec2-user/.ssh/group5-staging.pub"
  description = "Path to the public key to use in every VMs provisioning"
  type        = string
}