
locals {
  name = var.project_name
  tags = { Project = var.project_name, Managed = "terraform" }
}

module "network" {
  source = "./modules/network"

  project_name    = local.name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.tags
}

module "app" {
  source = "./modules/app"

  project_name = local.name
  vpc_id       = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  app_instance_type = var.app_instance_type
  tags = local.tags
}

module "db" {
  source = "./modules/db"

  project_name = local.name
  vpc_id       = module.network.vpc_id
  private_subnets = module.network.private_subnets
  db_username  = var.db_username
  db_password  = var.db_password
  db_allocated_storage = var.db_allocated_storage
  tags = local.tags
}
