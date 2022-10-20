#--------------------------------------------------------------------------------------------------
#
# Retrieve Availability Zones
#
#--------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

output "availabilty-zones" {
  value = data.aws_availability_zones.available
}

#--------------------------------------------------------------------------------------------------
#
# Retrieve the ami id for the Ubuntu image
#
# and provide the result as: "${data.aws_ami.ubuntu.id}"
#
#--------------------------------------------------------------------------------------------------
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

output "ubuntu-ami" {
  value = data.aws_ami.ubuntu
}
