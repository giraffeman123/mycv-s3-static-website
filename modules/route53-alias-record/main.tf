# Retrieve information about your hosted zone from AWS
data "aws_route53_zone" "this" {
  name = var.main_domain_name
}

resource "aws_route53_record" "alias_record" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.static_website_domain
  type    = "A"
  alias {
    name                   = var.cf_dist_domain_name
    zone_id                = var.cf_dist_hosted_zone_id
    evaluate_target_health = false
  }
}
