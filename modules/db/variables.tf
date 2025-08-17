
variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "db_username" { type = string }
variable "db_password" { type = string, sensitive = true }
variable "db_allocated_storage" { type = number }
variable "tags" { type = map(string) }
