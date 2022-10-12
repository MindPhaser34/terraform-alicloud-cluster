// Output kubernetes resource
output "k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.new-project.*.name, [""])[0]
}
output "k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.new-project.*.id, [""])[0]
}
output "k8s_nodes" {
  description = "List nodes of cluster."
  value       = concat(alicloud_cs_managed_kubernetes.new-project.*.worker_nodes, [""])[0]
}
output "k8s_node_ids" {
  description = "List ids of of cluster node."
  value       = [for _, obj in concat(alicloud_cs_managed_kubernetes.new-project.*.worker_nodes, [{}])[0] : lookup(obj,"id")]
}

// Output VPC
output "vpc_id" {
  description = "The ID of the VPC."
  value       = concat(alicloud_cs_managed_kubernetes.new-project.*.vpc_id, [""])[0]
}
output "vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = length(var.vswitch_ids) > 0 ? var.vswitch_ids : alicloud_vswitch.new-project.*.id
}
output "security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.new-project.*.security_group_id, [""])[0]
}
