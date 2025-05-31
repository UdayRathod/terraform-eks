variable "aws_region" {
  type        = string
  description = "AWS region to use for resources."
  default     = "us-west-2"
}

variable "vpc-name" {
  type        = string
  description = "VPC name to use."
  default     = "eks-vpc"
}

variable "vpc-cidr" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "public-subnets-cidr" {
  type        = string
  description = "Public CIDR Block for VPC"
  default     = "10.1.0.0/24"
}

variable "private-subnets-cidr" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.2.0.0/24"
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "Base CIDR Block for VPC"
  default     = "2"
}

variable "vpc_private_subnet_count" {
  type        = number
  description = "Base CIDR Block for VPC"
  default     = "4"
}

variable "eks-cluster-version" {
  type        = number
  description = "Base CIDR Block for VPC"
  default     = "1.31"
}