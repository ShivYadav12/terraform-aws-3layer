# 🚀 Terraform 3-Layer AWS Infrastructure

This project sets up a **secure and scalable 3-layer cloud infrastructure on AWS** using **Terraform**.  
It follows the classic layered approach:

- **Network Layer** 🛰️  
  - VPC, subnets (public & private), route tables  
  - Internet Gateway & NAT Gateway for controlled traffic flow  

- **Application Layer** ⚙️  
  - Auto Scaling Group (ASG) with Launch Template  
  - Private subnets for application servers  
  - Security groups to restrict access  

- **Data Layer** 🗄️  
  - Amazon RDS (MySQL) deployed in private subnets  
  - Subnet group for database high availability  
  - DB not publicly accessible  

Additionally, a **GitHub Actions workflow** is included to automate `terraform fmt`, `validate`, `plan` (on Pull Requests) and `apply` (on `main` branch).

---

## 📂 Project Structure

