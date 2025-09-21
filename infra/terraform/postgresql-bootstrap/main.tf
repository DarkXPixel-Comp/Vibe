terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "auth_service" {
  length  = 16
  special = false
}

resource "kubernetes_secret" "auth_service" {
  metadata {
    name      = "auth-service-db-secret"
    namespace = "database"
  }
  data = {
    username = base64encode("auth_service")
    password = base64encode(random_password.auth_service.result)
  }
}

resource "kubernetes_manifest" "postgres_cluster" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    metadata = {
      name      = "postgres"
      namespace = "database"
    }
    spec = {
      instances = 1
      storage = {
        size = "1Gi"
      }
      managed = {
        roles = [
          {
            name           = "auth_service"
            ensure         = "present"
            login          = true
            superuser      = false
            passwordSecret = { name = "auth-service-secret" }
          },
          {
            name           = "billing_service"
            ensure         = "present"
            login          = true
            superuser      = false
            passwordSecret = { name = "billing-service-secret" }
          }
        ]
      }
    }
  }
  depends_on = [
    kubernetes_secret.auth_service,
    kubernetes_secret.billing_service
  ]
}

