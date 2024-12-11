variable "vpc_id" {
  type = string
}
variable "subnet_cidr_blocks" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "automatic_public_ip" {
  type = bool
}
variable "vpc_cidr_block" {
  type = string
}
variable "access_modifier" {
  type = string
}
variable "nat_subnet_id" {
  type = string
  default = null
}
variable "region" {
  type = string
}
variable "nat_az" {
  type = string
  default = null
}