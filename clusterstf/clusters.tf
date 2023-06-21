terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

//Karmada manager cluster

resource "linode_lke_cluster" "lke_cluster" {
    k8s_version = var.lke_cluster[0].k8s_version
    label = var.lke_cluster[0].label
    region = var.lke_cluster[0].region

    dynamic "pool" {
        for_each = var.lke_cluster[0].pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
}

//Exportando los valores el cluster para la posterior administracion

output "kubeconfig_cluster" {
   value = linode_lke_cluster.lke_cluster.kubeconfig
   sensitive = true
}

variable "lke_cluster"{}
