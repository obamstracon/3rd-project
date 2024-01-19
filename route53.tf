variable "domain_name" {
  default = ""
  type = string
  description = "domain_name"
}

resource "aws_route53_zone" "hosted_zone" {
    name = var.domain_name
    tags = {
      Environment = "dev"
    }
  
}

resource "aws_route53_records" "site_domain" {
    zone_id = aws_route53_zone.hosted_zone.id
    name = "terraform-test.${var.domain_name}"
    type = "A"

    alias {
        name = aws_lb.obam-load-balancer.dns_name
        zone_id = aws_lb.obam-load-balancer.zone_id
        evaluate_target_healtth = true
    }
  
}