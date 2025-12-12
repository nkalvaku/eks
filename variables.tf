variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

# MASTER in 172.31.0.0/16
variable "master_vpc_id" {
  description = "VPC ID for VictoriaMetrics master EKS cluster"
  type        = string
  default     = "vpc-67b4ba0f"  # 172.31.0.0/16
}

# AGENT in 10.0.0.0/16
variable "agent_vpc_id" {
  description = "VPC ID for VictoriaMetrics agent EKS cluster"
  type        = string
  default     = "vpc-079c8972b8a460e68"  # 10.0.0.0/16 (main)
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}
