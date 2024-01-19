resource "aws_security_group" "obam-load_balancer_sg" {
    name            = "obam-load_balancer_sg"
    description     = "security group for the load balancer"
    vpc_id          = aws_vpc.obam_vpc.id  


    ingress  {
        from_port    = 443
        to_port      = 443
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]

    }


    ingress = {
        from_port    = 80      
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]
    
    }


    egress   {
         from_port    = 80
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]
    }
}


resource "aws_security_group" "obam-seurity-group-rule" {
    name                = "allow_ssh_http_https"
    description         = "allow SSH, HTTP, HTTPS, inbound trafficfor public instances"
    vpc_id              = aws_vpc.obam_vpc.id



    ingress {
        description  = "HTTP"
        from_port    = 80      
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]
        security_groups = [aws_security_group.obam-load_balancer_sg.id]
    }


    ingress {
         description = "HTTPS"
        from_port    = 443
        to_port      = 443
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]
        security_groups = [aws_security_group.obam-load_balancer_sg.id]
    }


    ingress {
        description = "SSH"
        from_port    = 22
        to_port      = 22
        protocol     = "tcp"
        cidr_blocks  = ["0.o0.0.0/0"]
    }


    tags = {
      Nane = "obam-security-grp-rule"
    }
  
}