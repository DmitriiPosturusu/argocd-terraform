data "google_container_cluster" "this" {
  name = var.eks_cluster_name
}

data "google_client_config" "this" {
}

provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.this.endpoint
    token                  = data.google_client_config.this.token
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].data)
  }
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm" # Official Chart Repo
  chart            = "argo-cd"                              # Official Chart Name
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  values           = [file("${path.module}/argocd.yaml")]
}
