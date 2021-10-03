#Creating a Load Balancer. Load balancers can only be run across two subnets at the least

resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "Jenkins-LB"
  }
}

#Create a Target group for the ALB in us-east-1
resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_master.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "jenkins-target-group"
  }
}


#Create a Listener to be attached to the ALB in us-east-1
resource "aws_lb_listener" "jenkins-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  #(This Default action below must be preent in all listeners)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}


#Then create a listener for port 443
#resource "aws_lb_listener" "jenkins-listener-https" {
#	provider = aws.region-master
#	load_balancer_arn = aws_lb.application-lb.arn
#	ssl_policy = "ELBSecurityPolicy-2016-08"
#	port = "443"
#	protocol = "HTTPS"
#	certificate_arn = aws_acm_certificate.jenkins-lb-https.arn
#	default_action {
#		type = "forward"
#		target_group_arn = aws_lb_target_group.app-lb-tg.arn
#	}
#}



#Create a target group attachment to be attached to the ALB
resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.jenkins-master.id
  port             = var.webserver-port
}
