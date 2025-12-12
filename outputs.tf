output "vm_master_cluster_name" {
  value = module.eks_master.cluster_name
}

output "vm_master_kubeconfig" {
  value     = module.eks_master.kubeconfig
  sensitive = true
}

output "vm_agent_cluster_name" {
  value = module.eks_agent.cluster_name
}

output "vm_agent_kubeconfig" {
  value     = module.eks_agent.kubeconfig
  sensitive = true
}
