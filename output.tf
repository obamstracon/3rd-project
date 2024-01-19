output "vpc_id" {
    value = aws_vpc.obam_vpc.id
  
}


output "elb_load_balancer_dns_name" {
    value = aws_lb_load_balancer_dns_name
  
}