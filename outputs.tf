
output "vpc_id" {
  value = module.network.vpc_id
}

output "app_asg_name" {
  value = module.app.asg_name
  description = "AutoScaling Group name for app layer"
}

output "rds_endpoint" {
  value = module.db.rds_endpoint
  description = "RDS endpoint for data layer"
  sensitive = true
}
