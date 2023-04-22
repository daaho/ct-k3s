#--------------------------------------------------------------------------------------------------
#
# EC2 Jump Host
#
#--------------------------------------------------------------------------------------------------
resource "aws_instance" "jump-host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "ct-k3s"
  monitoring    = false

  subnet_id              = data.aws_subnets.all-public-subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_from_everywhere.id]

  user_data = <<EOF
#!/bin/bash
echo "Install additional software"
apt update -y
apt install -y net-tools

echo "create ssh private key"
mkdir -p /home/ubuntu/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEApoKSHNsW/KY4JgzvJQUnN+xsS9e+eYH1kgf8m8NPsHYv4QkV
y2exkIklwbIUupk1tPi2W+lV1o+lAGlvneBMJXPqvpj21dyBC/rW08C98zx9Li9F
VfzuvnlifGplexkLF2fFHf3wPg7ZBMy0938vC1ARznGRsV8E/tI7mwOLsLZClBaY
ZDnwN9tlFQgc3zy/vMIWz9fuHm9wxZAm3PL9AXL27+iy0wnyrThcoSDI9ibOd49f
zD06qnZAT8TeQ6lHeqHPVoaWWdruJDIkf1zioIODzKITJxUbLqfMnnpZhJ0zkSUt
s7Ojfnj8SlfBjHvvUXFyQtbrdAp4FxOrmSLewwIDAQABAoIBAQCK7umxkBE3EA5L
mYE1F36ox+l4wvRYeFqJ1YYuBaKJb6P1ldoMlWHwYq8RVmC7bbkFXnzyZdhMpiCc
Hl2Wkp+WpIjbLdDPkyRN9aeomeskeHVOwvyMifY/EhNeEnzIYJYDmn87zjXV4hes
TI428HU1cELbSaGyKMGHSa2YYzX8ZE5997a/ZxdHNKkj5U1OzNQ7XOaJQPl5mJee
HEi+aWjKY0I8Xqq17R9vXOdZfPnO6KUIFSfA05BGtHfYBuRs67yF+y0diyesHgiy
r7EoK9+Xd/u78CVW3+9KiMgI3m1OFwSsi/5+8fGPqLmNitj4ZnY36N6hO3uikPR1
msbZ0Wp5AoGBANeVAy1q1L4qpqOLi1Z3ZT5e2nhngiOvj/aueDZNt8dklewmUyd4
kj1+sb6uwT6RNcMbrPoaAoepD9BQc7QXiFSJtoUPO+g5/5wSLv0wZRjQ9UrmS3Jv
jYuvCOMfoNpWAkiibDZncWiNnKXMond7f2mSlVge5HJIkXI2hNVQTxCtAoGBAMW6
UTmIM43YeT/0VibGP7YZQRQdT62OBNM8vPbX8a4uiJzPi1CY8YFfqV1YMxjzud9y
jSu5lR4nr9deKoHahQFVW6ardNh+5KM/1oVFpZiJPH7x9WCK3J5SnevvrBlmBgg8
eZK/kT9UTeuLgxnXPNzKybOAiuZaKKtJeEsZkOsvAoGAeba20YiUTj10UbeyVoIY
Vitlez8tWYqAZEzCsB4W2WtvvaExp4JKRo/mOHsfvXxsdxiEA7x1mzQXKoyRlqcG
oHwT4XHlZ8p/BxW5E9ej7GvlYYE+LYDP0IJlKR4tSbfvmCSjpd+nRtlVDMLJI15F
ZEyPJu5iGifgfjRLsMejrA0CgYAXJ+G5Rh0bgH16ouev9MmjTsPTUjdxkM852cQb
eGCiUGrJSnj7QF4QE57nApxBUNG0vFqSA1LWTDmIlEuQF4I6DMAF/dBaRkoKYECE
LQremTvPdhCRdNGvbOd3qQLTmqIcNtDaAbtF2l6hth3tWcqT5N/IOMaLgYV/wcPn
r5/MGwKBgFy0nv8g7juUsFp2N7zHzx5gwqaEQZM5eNQSPSNtwTrtcP4YcbkAHM8X
1Sk14jO/lX2Aehcs9HuNQizcrC1+P3RECTe09UCsEBCpIEW85+W/5XapPqcC2FJV
Z3Tq/euRiHHcW5wR7NVw+/eawaS/uvfDjz7zK+FQSJuPf0SHFMQ2
-----END RSA PRIVATE KEY-----" > /home/ubuntu/.ssh/id_rsa
chmod 600 /home/ubuntu/.ssh/id_rsa
EOF

  tags = {
    Name = "jump-host"
  }
}

output "aws_instance-jump-host" {
  value = aws_instance.jump-host
}


#--------------------------------------------------------------------------------------------------
#
# EC2 k3s Instances
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
