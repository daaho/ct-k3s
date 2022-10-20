#--------------------------------------------------------------------------------------------------
#
# AWS Region
#
#--------------------------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "eu-central-1"
}

#--------------------------------------------------------------------------------------------------
#
# VPC
#
#--------------------------------------------------------------------------------------------------
variable "vpc_name" {
  description = "Name for VPC"
  type        = string
  default     = "k3s"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "enable_dns_support" {
  description = "CIDR block for VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "CIDR block for VPC"
  type        = bool
  default     = true
}
