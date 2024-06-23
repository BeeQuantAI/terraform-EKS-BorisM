resource "argocd_application" "beequantai-argo-application" {
  metadata {
    name      = "beequantai-argo-application"
    namespace = "argocd"
  }
  spec {
    project   = "default"
    source {        
        repo_url          = "https://github.com/BeeQuantAI/Eks-GitOps.git"
        target_revision   = "HEAD"
        path            = "dev"
    }
    destination {
        server    = "https://kubernetes.default.svc"
        namespace = "uat"
    }
    sync_policy {
      sync_options = ["CreateNamespace=true"]

      automated {
        prune   = true
        self_heal= true
      }
    }
  }
}