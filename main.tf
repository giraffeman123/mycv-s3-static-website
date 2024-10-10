module "s3_static_website" {
  source      = "./modules/s3-static-website"
  bucket_name = var.static_website_domain
}

module "tls_certificate" {
  source      = "./modules/tls-certificate"
  domain_name = var.static_website_domain
}

module "route53_validate_cert" {
  source      = "./modules/route53-validate-cert"
  main_domain_name = var.main_domain_name  
  certificate_arn = module.tls_certificate.cert_arn
  domain_validation_options = module.tls_certificate.domain_validation_options
}

module "cloudfront_distribution" {
  source                      = "./modules/cloudfront-distribution"
  bucket_id                   = module.s3_static_website.bucket_id
  static_website_domain       = var.static_website_domain  
  bucket_regional_domain_name = module.s3_static_website.bucket_regional_domain_name
  
  acm_certificate_arn = module.tls_certificate.cert_arn
  depends_on = [ module.route53_validate_cert ]  
}

module "s3_cf_policy" {
  source              = "./modules/s3-cf-policy"
  bucket_id           = module.s3_static_website.bucket_id
  bucket_name         = var.static_website_domain
  cf_distribution_arn = module.cloudfront_distribution.cf_distribution_arn
}

module "route53_alias_record" {
  source      = "./modules/route53-alias-record"
  main_domain_name = var.main_domain_name
  static_website_domain = var.static_website_domain
  cf_dist_domain_name = module.cloudfront_distribution.cf_dist_domain_name
  cf_dist_hosted_zone_id = module.cloudfront_distribution.cf_dist_hosted_zone_id
  depends_on = [ module.cloudfront_distribution ]
}