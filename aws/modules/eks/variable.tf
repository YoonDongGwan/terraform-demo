variable "cluster_name" {
  type = string
}
variable "subnet_list" {
  type = list(string)
}
variable "bastion_ip" {
  type = string
}
variable "node_group_instance_type" {
  type = string
}
variable "scaling_desired_size" {
  type = string
}
variable "scaling_max_size" {
  type = string
}
variable "scaling_min_size" {
  type = string
}
variable "node_group_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "endpoint_private_access" {
  type = bool
}
variable "endpoint_public_access" {
  type = bool
}
variable "region" {
  type = string
}