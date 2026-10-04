variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "address_space" { type = list(string) }
variable "container_apps_subnet_name" { type = string }
variable "container_apps_subnet_cidrs" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
