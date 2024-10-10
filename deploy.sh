#!/bin/bash

terraform init

#--- deploying s3 static website first
echo "--------------------------------deploying s3 static website first--------------------------------"
terraform plan -var-file="dev.tfvars" -target module.s3_static_website -out terraform.tfplan
terraform apply terraform.tfplan

#--- request tls certificate for s3 static website domain
echo "--------------------------------request tls certificate for s3 static website domain--------------------------------"
terraform plan -var-file="dev.tfvars" -target module.tls_certificate -out terraform.tfplan
terraform apply terraform.tfplan

#--- add cname record in route53 to validate newly created tls certificate for s3 static website domain
echo "--------------------------------add cname record in route53 to validate newly created tls certificate for s3 static website domain--------------------------------"
terraform plan -var-file="dev.tfvars" -target module.route53_validate_cert -out terraform.tfplan
terraform apply terraform.tfplan

#--- deploy cloudfront distribution 
echo "--------------------------------deploying cloudfront distribution --------------------------------"
terraform plan -var-file="dev.tfvars" -target module.cloudfront_distribution -out terraform.tfplan
terraform apply terraform.tfplan

#--- deploy s3 bucket policy allowing access only through cloudfront
echo "--------------------------------deploying s3 bucket policy allowing access only through cloudfront--------------------------------"
terraform plan -var-file="dev.tfvars" -target module.s3_cf_policy -out terraform.tfplan
terraform apply terraform.tfplan

#--- deploy alias record for cloudfront distribution
echo "--------------------------------deploy alias record for cloudfront distribution--------------------------------"
terraform plan -var-file="dev.tfvars" -target module.route53_alias_record -out terraform.tfplan
terraform apply terraform.tfplan
