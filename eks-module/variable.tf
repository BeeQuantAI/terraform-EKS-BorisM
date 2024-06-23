variable "cluster_name" {
  type = string
}
variable "node_group_name" {
  type = string
}
variable "node_group_desired_size" {
  type = number
}
variable "node_group_max_size" {
  type = number
}
variable "node_group_min_size" {
  type = number
}
variable "clusterServiceRoleName" {
  type = string
}
variable "BeeQuantAI_subnets_id" {
  type = list(string)
}
variable "BeeQuantAI_vpc_id" {
  type = string
}
variable "nodegroupServiceRoleName" {
  type = string
}
variable "node_group_instance_type" {
  type = list(string)
}