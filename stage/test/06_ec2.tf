#--------------------------------------------------------------------------------------------------
#
# EC2 Instances
#
#--------------------------------------------------------------------------------------------------
resource "aws_instance" "k3s-nodes" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "ct-k3s"
  monitoring    = false

  count                  = length(data.aws_subnets.all-private-subnets.ids)
  subnet_id              = data.aws_subnets.all-private-subnets.ids[count.index]
  vpc_security_group_ids = [aws_security_group.allow_ssh_from_everywhere.id]

  tags = {
    Name = "k3s-node-${count.index}"
  }
}

data "aws_instances" "k3s-nodes" {
  filter {
    name   = "tag:Name"
    values = ["k3s-node*"]
  }
}

output "aws-instances-k3s-nodes" {
  value = data.aws_instances.k3s-nodes
}
