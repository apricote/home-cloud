resource "kubernetes_service_account" "dashboard" {
  metadata {
    name      = "dashboard-admin"
    namespace = "kube-system"

    labels = {
      app = "dashboard"
    }
  }
}

resource "kubernetes_cluster_role_binding" "dashboard" {
  metadata {
    name = "dashboard-admin"

    labels = {
      app = "dashboard"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "dashboard-admin"
    namespace = "kube-system"
  }
}
