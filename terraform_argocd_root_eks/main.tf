data "google_container_cluster" "this" {
  name = var.eks_cluster_name
}

data "google_client_config" "this" {
}

provider "kubernetes" {
  host                   = data.google_container_cluster.this.endpoint
  token                  = data.google_container_cluster.this.token
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].data)
}


resource "kubernetes_manifest" "argocd_root" {
  manifest = yamldecode(templatefile("${path.module}/root.yaml", {
    path           = var.git_source_path
    repoURL        = var.git_source_repoURL
    targetRevision = var.git_source_targetRevision
  }))
}
