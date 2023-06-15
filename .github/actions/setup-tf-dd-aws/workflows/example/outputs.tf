output "dd_test_pod_log_monitor_id" {
  description = "id for monitor pod_log_monitor_id"
  value       = module.test_eks_monitor.pod_log_monitor_id
}
output "dd_test_node_status_monitor_id" {
  description = "id for monitor node_status_monitor_id"
  value       = module.test_eks_monitor.node_status_monitor_id
}
output "dd_test_node_ready_monitor_id" {
  description = "id for monitor node_ready_monitor_id"
  value       = module.test_eks_monitor.node_ready_monitor_id
}
output "dd_test_deployment_status_monitor_id" {
  description = "id for monitor deployment_status_monitor_id"
  value       = module.test_eks_monitor.deployment_status_monitor_id
}
output "dd_test_statefulset_status_monitor_id" {
  description = "id for monitor statefulset_status_monitor_id"
  value       = module.test_eks_monitor.statefulset_status_monitor_id
}
output "dd_test_daemonset_status_monitor_id" {
  description = "id for monitor daemonset_status_monitor_id"
  value       = module.test_eks_monitor.daemonset_status_monitor_id
}
output "dd_test_crashloop_backoff_monitor_id" {
  description = "id for monitor crashloop_backoff_monitor_id"
  value       = module.test_eks_monitor.crashloop_backoff_monitor_id
}
output "dd_test_imagepull_backoff_monitor_id" {
  description = "id for monitor imagepull_backoff_monitor_id"
  value       = module.test_eks_monitor.imagepull_backoff_monitor_id
}
output "dd_test_network_rx_error_monitor_id" {
  description = "id for monitor network_rx_error_monitor_id"
  value       = module.test_eks_monitor.network_rx_error_monitor_id
}
output "dd_test_network_tx_error_monitor_id" {
  description = "id for monitor network_tx_error_monitor_id"
  value       = module.test_eks_monitor.network_tx_error_monitor_id
}
output "dd_test_pod_cpu_usage_monitor_id" {
  description = "id for monitor pod_cpu_usage_monitor_id"
  value       = module.test_eks_monitor.pod_cpu_usage_monitor_id
}
output "dd_test_pod_memory_usage_monitor_id" {
  description = "id for monitor pod_memory_usage_monitor_id"
  value       = module.test_eks_monitor.pod_memory_usage_monitor_id
}
output "dd_test_pod_pending_monitor_id" {
  description = "id for monitor pod_pending_monitor"
  value       = module.test_eks_monitor.pod_pending_monitor_id
}
output "dd_test_pod_terminated_monitor_id" {
  description = "id for monitor pod_terminated_monitor"
  value       = module.test_eks_monitor.pod_terminated_monitor_id
}
output "dd_test_pod_crash_monitor_id" {
  description = "id for monitor pod_crash_monitor"
  value       = module.test_eks_monitor.pod_crash_monitor_id
}
