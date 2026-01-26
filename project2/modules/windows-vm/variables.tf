variable "vm_name" {}
variable "vm_count" { default = 2 }
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "lb_backend_pool_id" {}
variable "vm_size" { default = "Standard_D2s_v3" }
variable "admin_username" {}
variable "admin_password" { sensitive = true }


