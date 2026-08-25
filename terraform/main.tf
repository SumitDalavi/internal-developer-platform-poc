provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "idp" {
  metadata {
    name = "idp"
  }
}

resource "kubernetes_deployment" "backstage" {
  metadata {
    name      = "backstage"
    namespace = kubernetes_namespace.idp.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backstage"
      }
    }
    template {
      metadata {
        labels = {
          app = "backstage"
        }
      }
      spec {
        container {
          name  = "backstage"
          image = "backstage:latest"
          port {
            container_port = 7007
          }
        }
      }
    }
  }
}
