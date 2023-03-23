variable "Name" {
  type = string
  description = "please enter you name = "
}
variable "Project" {
  type = string
  description = "What is your Terra-Project name = "
}
variable "Environment" {
  type = string
  description = "What is your environment = "
}

variable "cidr_block" {
  type = string
  description = "Enter the cidr_blocks = "
}
variable "public_network" {
  type = string
  description = "Enter the public_network_cidr_blocks = "
}
variable "private_network" {
  type = string
  description = "Enter the private_network_cidr_blocks = "
}

variable "tags" {
  type = string
  description = "Additional tags for your resource"
}