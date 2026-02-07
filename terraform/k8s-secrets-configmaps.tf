# Secret for LMS DB credentials
resource "kubernetes_secret" "lms_db_secret" {
  metadata {
    name      = "lms-db-secret"
    namespace = "openedx-lms"
  }
  data = {
    username = var.db_username
    password = var.db_password
  }
}

# ConfigMap for LMS service endpoint
resource "kubernetes_config_map" "lms_config" {
  metadata {
    name      = "lms-config"
    namespace = "openedx-lms"
  }
  data = {
    DB_HOST            = module.rds.mysql_endpoint
    MONGO_HOST         = module.mongodb.mongodb_private_ip
    REDIS_HOST         = module.redis.redis_endpoint
    ELASTICSEARCH_HOST = module.elasticsearch.opensearch_endpoint
  }
}

# Secret for CMS DB credentials
resource "kubernetes_secret" "cms_db_secret" {
  metadata {
    name      = "cms-db-secret"
    namespace = "openedx-cms"
  }
  data = {
    username = var.db_username
    password = var.db_password
  }
}

# ConfigMap for CMS service endpoints
resource "kubernetes_config_map" "cms_config" {
  metadata {
    name      = "cms-config"
    namespace = "openedx-cms"
  }
  data = {
    DB_HOST            = module.rds.mysql_endpoint
    MONGO_HOST         = module.mongodb.mongodb_private_ip
    REDIS_HOST         = module.redis.redis_endpoint
    ELASTICSEARCH_HOST = module.elasticsearch.opensearch_endpoint
  }
}

# -------------------------------
# NEW: SMTP Secret (for email)
# -------------------------------
resource "kubernetes_secret" "smtp_secret" {
  metadata {
    name      = "smtp-secret"
    namespace = "openedx-lms"
  }
  data = {
    EMAIL_HOST          = var.email_host
    EMAIL_PORT          = var.email_port
    EMAIL_HOST_USER     = var.email_host_user
    EMAIL_HOST_PASSWORD = var.email_host_password
    DEFAULT_FROM_EMAIL  = var.default_from_email
  }
}

# -------------------------------
# NEW: Platform ConfigMap
# -------------------------------
resource "kubernetes_config_map" "platform_config" {
  metadata {
    name      = "platform-config"
    namespace = "openedx-lms"
  }
  data = {
    LMS_HOST      = var.lms_host
    CMS_HOST      = var.cms_host
    PLATFORM_NAME = var.platform_name
    MEDIA_ROOT    = "/openedx/media"
    STATIC_ROOT   = "/openedx/static"
  }
}
