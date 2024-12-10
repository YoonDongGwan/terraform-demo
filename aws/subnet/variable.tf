variable "vpc_id" {
  type = string
}
variable "subnet_cidr_blocks" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "subnet_name" {
  type = string
}
variable "automatic_public_ip" {
  type = bool
}
variable "vpc_cidr_block" {
  type = string
}
variable "route_table_cidr_block" {
  type = string
}
variable "route_table_gateway_id" {
  type = string
}