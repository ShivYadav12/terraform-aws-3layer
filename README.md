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

terraform_3layer_aws/
├── main.tf # Root module, calls submodules
├── provider.tf # AWS provider + backend config
├── variables.tf # Input variables
├── outputs.tf # Output values
├── .gitignore # Ignore tfstate, .terraform, etc.
├── README.md # Project documentation
├── modules/
│ ├── network/ # VPC, subnets, NAT, IGW
│ ├── app/ # ASG, Launch Template, Security Group
│ └── db/ # RDS instance + subnet group
└── .github/
└── workflows/
└── terraform.yml # GitHub Actions workflow
