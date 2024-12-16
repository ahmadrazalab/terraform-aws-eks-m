### README for EKS Terraform Module

---

# EKS Terraform Module

This Terraform module provisions an **Amazon Elastic Kubernetes Service (EKS)** cluster with essential configurations, node groups, and managed add-ons. It is designed to be reusable and customizable, making it easy to integrate into other Terraform projects.

---

## Features

- **EKS Cluster**: Creates an EKS cluster with private subnets and customizable logging.
- **IAM Roles**: Automatically provisions IAM roles for the cluster and node groups.
- **Managed Add-Ons**: Supports EKS add-ons like `kube-proxy`, `vpc-cni`, `coredns`, and `eks-pod-identity-agent`.
- **Node Groups**: Configures auto-scaling node groups with custom IAM policies and subnet support.

---

## Usage

Include this module in your Terraform code:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "eks_cluster" {
  source = "ahmadrazalab/eks-m/aws"
  version = "v1.0.0" # Replace with the version you published
  eks_cluster_role_arn    = "arn:aws:iam::123456789012:role/eks-cluster-role"
  private_subnet_ids      = ["subnet-0198d10b83f4389a0", "subnet-0f4566efb7ac51c04", "subnet-0dfd99820b62e7ae7"]
  enabled_cluster_log_types = []
  cluster_tags            = {
    Name = "My Custom EKS Cluster"
    Env  = "production"
  }
  node_group_policies     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  node_group_desired_size = 1
  node_group_max_size     = 5
  node_group_min_size     = 1
  node_group_max_unavailable = 1
  node_group_tags = {
    Name = "Custom EKS Node Group"
    Env  = "production"
  }
}
```

---

## Inputs

The module accepts the following input variables:

| Name                       | Type         | Default                                                   | Description                                                                                     |
|----------------------------|--------------|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| `eks_cluster_role_arn`     | `string`     | **Required**                                              | IAM role ARN for the EKS cluster.                                                              |
| `private_subnet_ids`       | `list(string)` | **Required**                                              | List of private subnet IDs for the EKS cluster.                                                |
| `enabled_cluster_log_types`| `list(string)` | `[]`                                                      | List of log types to enable for the EKS cluster.                                               |
| `cluster_tags`             | `map(string)` | `{ Name = "Premium EKS Cluster", Env = "development" }`   | Tags to apply to the EKS cluster.                                                              |
| `node_group_policies`      | `list(string)` | See default                                               | List of IAM policies to attach to the EKS node group role.                                      |
| `node_group_desired_size`  | `number`     | `1`                                                       | Desired size of the node group.                                                                |
| `node_group_max_size`      | `number`     | `2`                                                       | Maximum size of the node group.                                                                |
| `node_group_min_size`      | `number`     | `1`                                                       | Minimum size of the node group.                                                                |
| `node_group_max_unavailable`| `number`    | `1`                                                       | Maximum number of unavailable nodes during updates.                                             |
| `node_group_tags`          | `map(string)` | `{ Name = "Premium EKS Node-1", Env = "development" }`    | Tags to apply to the EKS node group.                                                           |

---

## Outputs

The module provides the following outputs:

| Name            | Description                                  |
|-----------------|----------------------------------------------|
| `cluster_name`  | The name of the EKS cluster.                 |
| `cluster_endpoint` | The API endpoint of the EKS cluster.         |

---

## Pre-requisites

1. **IAM Role for the Cluster**  
   You need to create an IAM role with the following policies attached:
   - `AmazonEKSClusterPolicy`
   - `AmazonEKSVPCResourceController`

   Example:
   ```hcl
   resource "aws_iam_role" "eks_cluster_role" {
     name = "eks-cluster-role"

     assume_role_policy = jsonencode({
       Version = "2012-10-17",
       Statement = [
         {
           Effect = "Allow",
           Principal = {
             Service = "eks.amazonaws.com"
           },
           Action = "sts:AssumeRole"
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
     for_each = toset([
       "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
       "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
     ])

     role       = aws_iam_role.eks_cluster_role.name
     policy_arn = each.value
   }
   ```

2. **Subnets**  
   Ensure you have private subnets ready and pass their IDs as `private_subnet_ids` to the module.

---

## Example Deployment

Here’s a complete example:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "eks_cluster" {
  source = "ahmadrazalab/eks-m/aws"
  version = "v1.0.0" # Replace with the version you published
  eks_cluster_role_arn    = "arn:aws:iam::123456789012:role/eks-cluster-role"
  private_subnet_ids      = ["subnet-0198d10b83f4389a0", "subnet-0f4566efb7ac51c04", "subnet-0dfd99820b62e7ae7"]
  enabled_cluster_log_types = []
  cluster_tags            = {
    Name = "My Custom EKS Cluster"
    Env  = "production"
  }
  node_group_policies     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  node_group_desired_size = 1
  node_group_max_size     = 5
  node_group_min_size     = 1
  node_group_max_unavailable = 1
  node_group_tags = {
    Name = "Custom EKS Node Group"
    Env  = "production"
  }
}
```

---

## Notes

- **Region Configuration**: Ensure you configure the AWS provider with the desired region in your Terraform configuration.
- **Terraform Version**: This module supports Terraform 1.0+ and AWS Provider version `~> 5.0`.

---


## Contributing

Feel free to open issues or submit pull requests to improve the module.

--- 

