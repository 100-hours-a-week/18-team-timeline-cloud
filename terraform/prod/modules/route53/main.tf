resource "aws_route53_record" "frontend_alb_record" {
  zone_id = var.hosted_zone_id                     
  name    = "${var.domain_name}"               
  type    = "A"

  alias {
    name                   = var.frontend_dns_name
    zone_id                = var.frontend_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend_alb_record" {
  zone_id = var.hosted_zone_id                     
  name    = "api.${var.domain_name}"               
  type    = "A"

  alias {
    name                   = var.backend_dns_name           
    zone_id                = var.backend_zone_id             
    evaluate_target_health = true
  }
}