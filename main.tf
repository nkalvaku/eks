terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ----- Subnets in each VPC -----

data "aws_subnets" "master" {
  filter {
    name   = "vpc-id"
    values = [var.master_vpc_id]
  }
}

data "aws_subnets" "agent" {
  filter {
    name   = "vpc-id"
    values = [var.agent_vpc_id]
  }
}

# ----- MASTER CLUSTER (172.31.0.0/16 VPC) -----

module "eks_master" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "vm-master"
  cluster_version = var.cluster_version

  vpc_id     = var.master_vpc_id
  subnet_ids = data.aws_subnets.master.ids

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 2
      min_size     = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  manage_aws_auth_configmap = true

  tags = {
    Name        = "vm-master-eks"
    Environment = "lab"
    Role        = "victoriametrics-master"
  }
}

# ----- AGENT CLUSTER (10.0.0.0/16 VPC) -----

module "eks_agent" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "vm-agent"
  cluster_version = var.cluster_version

  vpc_id     = var.agent_vpc_id
  subnet_ids = data.aws_subnets.agent.ids

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 2
      min_size     = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  manage_aws_auth_configmap = true

  tags = {
    Name        = "vm-agent-eks"
    Environment = "lab"
    Role        = "victoriametrics-agent"
  }
}
