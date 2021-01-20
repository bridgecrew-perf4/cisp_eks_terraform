## ALB
resource "aws_lb" "main" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
#  security_groups    = Criar recurso posteriormente
  subnets            = aws_subnet.public[*].id
#  enable_deletion_protection = true
}

