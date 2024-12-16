variable "vpc_id" {
  type = string
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "master_password" {
  type = string
}
variable "master_username" {
  type = string
}
variable "availability_zones" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "eks_subnet_cidr_block" {
  type = list(string)
}