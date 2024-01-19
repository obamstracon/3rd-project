resource "aws_lb" "obam-load-balancer" {
    name = "obam-load-balancer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group-obam-load_balancer_sg.id]
    subnets = [aws_subnet.obam-public-subnet1.id, aws_subnet.obam-public-subnet2.id]
    enable_deletion_protection = false
    depends_on = [ aws_instance.obam-1, aws_instance.obam-2, aws_instance.obam-3]
  
}

resource "aws_load_target_group" "obam-target-group" {
    name = "obam-target-group"
    target_type = "instance"
    port = 80 
    protocol = "HTTP"
    vpc_id = aws_vpc.obam_vpc.id
    


   health_check  {
    
    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 15 

    timeout = 3

    healthy_threshold = 3
    
    unhealthy_threshold = 3
   }
  
}


resource "aws_lb_listener" "obam-listener" {
    load_balancer_arn = aws_lb.obam-load-balancer.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.obam-target-group.arn
    }
  
}


resource "aws_lb_listener_rule" "obam-listemer-rule" { 
    listener_arn = aws_lb_listener.obam-listener.arn
    priority = 1


    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.obam-target-group.listener_arn

    }

    condition {
      path_pattern {
        values = ["/"]
      }
    }


  
}


resource "aws_lb_target_group_attachment" "obam-target-groupp-attachement1" {
  target_group_arn = aws_lb_target_group.obam-target-group.arn 
  target_id = aws_instance.obam-1.id 
  port = 80

}

resource "aws_lb_target_group_attachment" "obam-target-groupp-attachement2" {
  target_group_arn = aws_lb_target_group.obam-target-group.arn 
  target_id = aws_instance.obam-2.id
  port = 80 
  
}

resource "aws_lb_target_group_attachment" "obam-target-group-attachment" {
  target_group_arn = aws_lb_target_group.obam-target-group.arn 
  target_id = aws_instance.obam-3.id 
  port = 80
  
}