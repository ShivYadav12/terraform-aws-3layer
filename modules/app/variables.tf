
variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "app_instance_type" { type = string }
variable "tags" { type = map(string) }
