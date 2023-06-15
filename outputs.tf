output "pod_log_monitor_id" {
  description = "id for monitor pod_log_monitor_id"
  value       = datadog_monitor.pod_log_monitor.*.id
}
output "node_status_monitor_id" {
  description = "id for monitor node_status_monitor_id"
  value       = datadog_monitor.node_status_monitor.*.id
}
output "node_ready_monitor_id" {
  description = "id for monitor node_ready_monitor_id"
  value       = datadog_monitor.node_ready_monitor.*.id
}
output "deployment_status_monitor_id" {
  description = "id for monitor deployment_status_monitor_id"
  value       = datadog_monitor.deployment_status_monitor.*.id
}
output "statefulset_status_monitor_id" {
  description = "id for monitor statefulset_status_monitor_id"
  value       = datadog_monitor.statefulset_status_monitor.*.id
}
output "daemonset_status_monitor_id" {
  description = "id for monitor daemonset_status_monitor_id"
  value       = datadog_monitor.daemonset_status_monitor.*.id
}
output "crashloop_backoff_monitor_id" {
  description = "id for monitor crashloop_backoff_monitor_id"
  value       = datadog_monitor.crashloop_backoff_monitor.*.id
}
output "imagepull_backoff_monitor_id" {
  description = "id for monitor imagepull_backoff_monitor_id"
  value       = datadog_monitor.imagepull_backoff_monitor.*.id
}
output "network_rx_error_monitor_id" {
  description = "id for monitor network_rx_error_monitor_id"
  value       = datadog_monitor.network_rx_error_monitor.*.id
}
output "network_tx_error_monitor_id" {
  description = "id for monitor network_tx_error_monitor_id"
  value       = datadog_monitor.network_tx_error_monitor.*.id
}
output "pod_cpu_usage_monitor_id" {
  description = "id for monitor pod_cpu_usage_monitor_id"
  value       = datadog_monitor.pod_cpu_usage_monitor.*.id
}
output "pod_memory_usage_monitor_id" {
  description = "id for monitor pod_memory_usage_monitor_id"
  value       = datadog_monitor.pod_memory_usage_monitor.*.id
}
output "pod_pending_monitor_id" {
  description = "id for monitor pod_pending_monitor_id"
  value       = datadog_monitor.pod_pending_monitor.*.id
}
output "pod_terminated_monitor_id" {
  description = "id for monitor pod_terminated_monitor_id"
  value       = datadog_monitor.pod_terminated_monitor.*.id
}
output "pod_crash_monitor_id" {
  description = "id for monitor pod_crash_monitor_id"
  value       = datadog_monitor.pod_crash_monitor.*.id
}
