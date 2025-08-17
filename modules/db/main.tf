
resource "aws_db_subnet_group" "db_subnets" {
  name = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets
  tags = var.tags
}

resource "aws_db_instance" "rds" {
  identifier = "${var.project_name}-rds"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = var.db_allocated_storage
  name = "${var.project_name}_db"
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = []
  tags = var.tags
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
  sensitive = true
}
