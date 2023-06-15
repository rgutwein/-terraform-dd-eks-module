terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.14.0"
    }
  }
  required_version = ">= 0.13"
}

# A variety of checks to customize monitors
locals {
  pod_name  = var.app_name == "*" ? "*" : "${var.app_name}*"
  check_env = length(regexall(".*-${var.env}-.*", var.cluster_name)) > 0

  focus_logs       = length(var.focus_logs) == 0 && local.check_env ? "cluster_name:${var.cluster_name}" : var.focus_logs
  focus_monitors   = length(var.focus_monitors) == 0 && local.check_env ? ",cluster_name:${var.cluster_name}" : var.focus_monitors
  focus_node_ready = length(var.focus_node_ready) == 0 && local.check_env ? var.cluster_name : var.focus_node_ready

  notify_network_tx_error_monitor   = join(" ", length(var.notify_network_tx_error_monitor) > 0 ? var.notify_network_tx_error_monitor : var.notify_default_list)
  notify_network_rx_error_monitor   = join(" ", length(var.notify_network_rx_error_monitor) > 0 ? var.notify_network_rx_error_monitor : var.notify_default_list)
  notify_imagepull_backoff_monitor  = join(" ", length(var.notify_imagepull_backoff_monitor) > 0 ? var.notify_imagepull_backoff_monitor : var.notify_default_list)
  notify_crashloop_backoff_monitor  = join(" ", length(var.notify_crashloop_backoff_monitor) > 0 ? var.notify_crashloop_backoff_monitor : var.notify_default_list)
  notify_node_status_monitor        = join(" ", length(var.notify_node_status_monitor) > 0 ? var.notify_node_status_monitor : var.notify_default_list)
  notify_node_ready_monitor         = join(" ", length(var.notify_node_ready_monitor) > 0 ? var.notify_node_ready_monitor : var.notify_default_list)
  notify_deployment_status_monitor  = join(" ", length(var.notify_deployment_status_monitor) > 0 ? var.notify_deployment_status_monitor : var.notify_default_list)
  notify_daemonset_status_monitor   = join(" ", length(var.notify_daemonset_status_monitor) > 0 ? var.notify_daemonset_status_monitor : var.notify_default_list)
  notify_statefulset_status_monitor = join(" ", length(var.notify_statefulset_status_monitor) > 0 ? var.notify_statefulset_status_monitor : var.notify_default_list)
  notify_pod_log_monitor            = join(" ", length(var.notify_pod_log_monitor) > 0 ? var.notify_pod_log_monitor : var.notify_default_list)
  notify_pod_cpu_usage_monitor      = join(" ", length(var.notify_pod_cpu_usage_monitor) > 0 ? var.notify_pod_cpu_usage_monitor : var.notify_default_list)
  notify_pod_memory_usage_monitor   = join(" ", length(var.notify_pod_memory_usage_monitor) > 0 ? var.notify_pod_memory_usage_monitor : var.notify_default_list)
  notify_pod_pending_monitor        = join(" ", length(var.notify_pod_pending_monitor) > 0 ? var.notify_pod_pending_monitor : var.notify_default_list)
  notify_pod_terminated_monitor     = join(" ", length(var.notify_pod_terminated_monitor) > 0 ? var.notify_pod_terminated_monitor : var.notify_default_list)
  notify_pod_crash_monitor          = join(" ", length(var.notify_pod_crash_monitor) > 0 ? var.notify_pod_crash_monitor : var.notify_default_list)

  focus_deployment_status_monitor  = var.focus_deployment_status_monitor != "" ? var.focus_deployment_status_monitor : local.focus_monitors
  focus_statefulset_status_monitor = var.focus_statefulset_status_monitor != "" ? var.focus_statefulset_status_monitor : local.focus_monitors
  focus_daemonset_status_monitor   = var.focus_daemonset_status_monitor != "" ? var.focus_daemonset_status_monitor : local.focus_monitors
  focus_crashloop_backoff_monitor  = var.focus_crashloop_backoff_monitor != "" ? var.focus_crashloop_backoff_monitor : local.focus_monitors
  focus_imagepull_backoff_monitor  = var.focus_imagepull_backoff_monitor != "" ? var.focus_imagepull_backoff_monitor : local.focus_monitors
  focus_network_tx_error_monitor   = var.focus_network_tx_error_monitor != "" ? var.focus_network_tx_error_monitor : local.focus_monitors
  focus_network_rx_error_monitor   = var.focus_network_rx_error_monitor != "" ? var.focus_network_rx_error_monitor : local.focus_monitors
  focus_pod_cpu_usage_monitor      = var.focus_pod_cpu_usage_monitor != "" ? var.focus_pod_cpu_usage_monitor : local.focus_monitors
  focus_pod_memory_usage_monitor   = var.focus_pod_memory_usage_monitor != "" ? var.focus_pod_memory_usage_monitor : local.focus_monitors
  focus_pod_pending_monitor        = var.focus_pod_pending_monitor != "" ? var.focus_pod_pending_monitor : local.focus_monitors
  focus_pod_terminated_monitor     = var.focus_pod_terminated_monitor != "" ? var.focus_pod_terminated_monitor : local.focus_monitors
  focus_pod_crash_monitor          = var.focus_pod_crash_monitor != "" ? var.focus_pod_crash_monitor : local.focus_monitors

  tags = ["Domain:${var.tag_domain}", "Service:${var.app_name == "*" ? "K8s Infra" : var.app_name}", "Contact:${var.tag_contact}", "Repo:${var.tag_repo}", "Environment: ${var.env}", "Managed:Terraform"]
}
