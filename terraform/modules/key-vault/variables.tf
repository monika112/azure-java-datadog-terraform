variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "enable_rbac" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
