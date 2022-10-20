resource "aws_lb" "k3s" {
  name               = "alb-k3s"
  internal           = false
  load_balancer_type = "network"
#  count              = length(data.aws_subnets.all-public-subnets.ids)
  subnets            = data.aws_subnets.all-public-subnets.ids
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.alb-logs-daaho.bucket
  #   prefix  = "alb-k3s"
  #   enabled = true
  # }

  tags = {
    Name = "alb-k3s"
  }
}

resource "aws_lb_target_group" "k3s-nodes-ssh" {
  name     = "k3s-nodes-ssh"
  port     = 22
  protocol = "TCP"
  vpc_id     = aws_vpc.vpc.id
  target_type = "instance"

  tags = {
    Name = "k3s-nodes-ssh"
  }
}

resource "aws_lb_target_group_attachment" "k3s-nodes-ssh" {
  target_group_arn = aws_lb_target_group.k3s-nodes-ssh.arn
  count          = length(data.aws_instances.k3s-nodes.ids)
  target_id      = data.aws_instances.k3s-nodes.ids[count.index]
  port             = 22
}

resource "aws_lb_listener" "k3s-nodes-ssh" {
  load_balancer_arn = aws_lb.k3s.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s-nodes-ssh.arn
  }
}