# Terraform AWS EKS Project

## Overview
This project sets up an AWS EKS cluster with Terraform using a modular structure. It provisions networking, EKS cluster, IAM roles, and policies, including access management using `aws_eks_access_policy_association`.

## Directory Structure (in-progress)
```
├── modules/
│   ├── eks/
│   ├── vpc/
│   └── ...
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── ...
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── ...
│   └── production/
│       ├── main.tf
│       ├── variables.tf
│       └── ...
├── versions.tf
├── backend.tf
├── iam.tf
├── access-entry.tf
└── README.md
```

## Prerequisites
- **Terraform** (>= 1.3.0)
- **AWS CLI**
- **kubectl**
- **IAM Permissions** to create AWS resources

## Terraform Backend Setup
This project stores the Terraform state file in an **S3 bucket**.

Update `backend.tf` with your bucket details:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-tf-state-bucket"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```
Run:
```sh
tf init
```

## Variables Configuration
Set the **private and public subnet IDs** in a `.tfvars` file:
```hcl
private_subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
public_subnet_ids  = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
```

## IAM Role and Policies
The `iam.tf` file creates necessary IAM roles for EKS:
```hcl
resource "aws_iam_role" "eks_autocluster_role" {
  name = "AmazonEKSAutoClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action    = ["sts:AssumeRole"]
    }]
  })
}
```

## Access Policy Setup
The `access-entry.tf` file manages access policies for the cluster:
```hcl
resource "aws_eks_access_policy" "admin_policy" {
  cluster_name = aws_eks_cluster.premium_cluster.name
  policy      = jsonencode({
    version = "eks/v1",
    statement = [{
      effect   = "Allow",
      action   = ["eks:ListClusters", "eks:DescribeCluster"],
      resource = "*"
    }]
  })
}

resource "aws_eks_access_policy_association" "admin-user" {
  cluster_name  = aws_eks_cluster.premium_cluster.name
  policy_arn    = aws_eks_access_policy.admin_policy.arn
  principal_arn = aws_iam_user.admin_user.arn
}
```

## Deployment Steps
### Initialize Terraform
```sh
terraform init
```

### Plan and Apply
```sh
terraform plan -var-file="environments/dev/dev.tfvars"
terraform apply -var-file="environments/dev/dev.tfvars" -auto-approve
```

### Verify Cluster
```sh
aws eks --region ap-south-1 update-kubeconfig --name premium-cluster
kubectl get nodes
```

## Destroy Infrastructure
To delete the EKS cluster and all resources:
```sh
terraform destroy -var-file="environments/dev/dev.tfvars" -auto-approve
```

## Notes
- This setup uses **S3 as backend** (no DynamoDB locking).
- Ensure you have the right **IAM permissions** before deployment.
- Modify `access-entry.tf` if additional roles need access.

