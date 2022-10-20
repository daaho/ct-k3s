#--------------------------------------------------------------------------------------------------
#
# VPC module
#
#--------------------------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"


  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames



  tags = {
    Name = var.vpc_name
  }
}

output "vpc" {
  description = "All info of VPC"
  value       = aws_vpc.vpc
}