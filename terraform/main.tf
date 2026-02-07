provider "aws" {
  region = var.region
}

# Get cluster auth token automatically from
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Kubernetes provider (automatic, no kubeconfig dependency)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Helm provider (automatic, same connection)
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# VPC module
module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

# EKS module
module "eks" {
  source            = "./modules/eks"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group    = module.vpc.security_group_id

  cluster_version    = var.cluster_version
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
}

# RDS MySQL module
module "rds" {
  source            = "./modules/rds"
  project_name      = var.project_name
  region            = var.region
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.private_subnets
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az
}

# MongoDB module
module "mongodb" {
  source       = "./modules/mongodb"
  project_name = var.project_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets
  key_name     = var.key_name
}

# Elasticsearch / OpenSearch module
module "elasticsearch" {
  source       = "./modules/elasticsearch"
  project_name = var.project_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets
}

# Redis module
module "redis" {
  source       = "./modules/redis"
  project_name = var.project_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets
}

# WAF + CloudFront module
module "waf_cloudfront" {
  source             = "./modules/waf-cloudfront"
  project_name       = var.project_name
  region             = var.region
  origin_domain_name = module.eks.cluster_endpoint
}

# Install cert-manager automatically
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.14.4"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# ClusterIssuer for Let's Encrypt
resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.acme_email
        privateKeySecretRef = {
          name = "letsencrypt-prod-key"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}

# Ingress with automatic TLS
resource "kubernetes_ingress_v1" "openedx_ingress" {
  metadata {
    name      = "openedx-ingress"
    namespace = "openedx-lms"
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    rule {
      host = "lms.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "lms-service"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }

    rule {
      host = "cms.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "cms-service"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = ["lms.${var.domain_name}", "cms.${var.domain_name}"]
      secret_name = "openedx-tls"
    }
  }
}

# EFS module
module "efs" {
  source        = "./modules/efs"
  project_name  = var.project_name
  vpc_id        = module.vpc.vpc_id
  subnets       = module.vpc.private_subnets
  allowed_cidrs = [var.vpc_cidr]
}

module "cloudwatch" {
  source          = "./modules/cloudwatch"
  log_group_name  = "/aws/eks/openedx"
  log_stream_name = "eks-log-stream"
  retention_days  = 30
  prefix          = "openedx"
  tags = {
    Environment = "prod"
    Project     = "openedx-monitoring"
  }
}
