output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_security_group" {
  value = module.vpc.security_group_id
}

output "rds_mysql_endpoint" {
  value = module.rds.mysql_endpoint
}

output "mongodb_private_ip" {
  value = module.mongodb.mongodb_private_ip
}

output "elasticsearch_endpoint" {
  value = module.elasticsearch.opensearch_endpoint
}

output "redis_endpoint" {
  value = module.redis.redis_endpoint
}

output "cloudfront_domain_name" {
  value = module.waf_cloudfront.cloudfront_domain_name
}

output "lms_url" {
  description = "Public LMS URL"
  value       = "https://lms.${var.domain_name}"
}

output "cms_url" {
  description = "Public CMS URL"
  value       = "https://cms.${var.domain_name}"
}

output "efs_id" {
  value = module.efs.efs_id
}

output "efs_dns_name" {
  value = module.efs.efs_dns_name
}