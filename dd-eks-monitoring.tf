# log monitor for eks deployment
resource "datadog_monitor" "pod_log_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod has a warning, error, exception, fail* or fatal log"
  count   = var.pod_logs_enabled ? 1 : 0
  type    = "log alert"
  query   = "logs(\"pod_name:${local.pod_name} ${var.pod_log_query} ${local.focus_logs}\").index(\"*\").rollup(\"count\").by(\"cluster_name,kube_namespace,pod_name\").last(\"5m\") > ${var.pod_log_threshold_critical}"
  message = "Please take a look why a warning, error, fatal or failure log(s) occurred on {{pod_name}}} in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_pod_log_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_log_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = false
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
  enable_logs_sample  = true
}

# status monitor for eks nodes
resource "datadog_monitor" "node_status_monitor" {
  name    = "EKS [${var.env}] - Detected Unschedulable Node(s)"
  count   = var.node_status_enabled ? 1 : 0
  type    = "query alert"
  query   = "max(last_15m):sum:kubernetes_state.node.status{status:schedulable${local.focus_monitors}} by {cluster_name,node} * 100 / sum:kubernetes_state.node.status{*} by {cluster_name,node} < ${var.node_status_threshold_critical}"
  message = "More than 20% of nodes are unschedulable on {{cluster_name}}. Please take a look why {{node}} is {{status}}. Notify: ${local.notify_node_status_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.node_status_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# ready monitor for eks nodes
resource "datadog_monitor" "node_ready_monitor" {
  name    = "EKS [${var.env}] - Node is NOT Ready"
  count   = var.node_ready_enabled ? 1 : 0
  type    = "service check"
  query   = "\"kubernetes_state.node.ready\".over(\"cluster_name:${local.focus_node_ready}\").by('cluster_name','host','node').last(5).count_by_status()"
  message = "Please take a look why node / host, {{node}} / {{host}}, is NOT Ready on {{cluster_name}}. Notify: ${local.notify_node_ready_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.node_ready_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# status monitor for eks deployments
resource "datadog_monitor" "deployment_status_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Deployment Replica Pod is down"
  count   = var.deployment_status_enabled ? 1 : 0
  type    = "query alert"
  query   = "min(last_15m):avg:kubernetes_state.deployment.replicas_desired{deployment:${local.pod_name}${local.focus_deployment_status_monitor}} by {cluster_name,kube_namespace,deployment} - avg:kubernetes_state.deployment.replicas_available{deployment:${local.pod_name}${local.focus_deployment_status_monitor}} by {cluster_name,kube_namespace,deployment} >= ${var.deployment_status_threshold_critical}"
  message = "Please take a look why {{deployment}}'s replica pod is down in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_deployment_status_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.deployment_status_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# status monitor for eks statefulsets
resource "datadog_monitor" "statefulset_status_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - StatefulSet Replica Pod is down"
  count   = var.statefulset_status_enabled ? 1 : 0
  type    = "query alert"
  query   = "min(last_15m):sum:kubernetes_state.statefulset.replicas_desired{statefulset:${local.pod_name}${local.focus_statefulset_status_monitor}} by {cluster_name,kube_namespace,statefulset} - sum:kubernetes_state.statefulset.replicas_ready{statefulset:${local.pod_name}${local.focus_statefulset_status_monitor}} by {cluster_name,kube_namespace,statefulset} >= ${var.statefulset_status_threshold_critical}"
  message = "Please take a look why {{statefulset}}'s replica pod is down in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_statefulset_status_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.statefulset_status_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# status monitor for eks daemonsets
resource "datadog_monitor" "daemonset_status_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - DaemonSet Replica Pod is down"
  count   = var.daemonset_status_enabled ? 1 : 0
  type    = "query alert"
  query   = "min(last_15m):sum:kubernetes_state.daemonset.desired{daemonset:${local.pod_name}${local.focus_daemonset_status_monitor}} by {cluster_name,kube_namespace,daemonset} - sum:kubernetes_state.daemonset.ready{daemonset:${local.pod_name}${local.focus_daemonset_status_monitor}} by {cluster_name,kube_namespace,daemonset} >= ${var.daemonset_status_threshold_critical}"
  message = "Please take a look why {{daemonset}}'s replica pod is down in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_daemonset_status_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.daemonset_status_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# crashloop backoff monitor
resource "datadog_monitor" "crashloop_backoff_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - CrashloopBackoff detected"
  count   = var.crashloop_backoff_enabled ? 1 : 0
  type    = "query alert"
  query   = "max(last_10m):max:kubernetes_state.container.status_report.count.waiting{reason:crashloopbackoff,pod_name:${local.pod_name}${local.focus_crashloop_backoff_monitor}} by {cluster_name,kube_namespace,pod_name} >= ${var.crashloop_backoff_threshold_critical}"
  message = "Please take a look why {{pod_name}} is CrashloopBackOff in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_crashloop_backoff_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.crashloop_backoff_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# image pull backoff monitor
resource "datadog_monitor" "imagepull_backoff_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - ImagePullBackOff detected"
  count   = var.imagepull_backoff_enabled ? 1 : 0
  type    = "query alert"
  query   = "max(last_10m):max:kubernetes_state.container.status_report.count.waiting{reason:imagepullbackoff,pod_name:${local.pod_name}${local.focus_imagepull_backoff_monitor}} by {cluster_name,kube_namespace,pod_name} >= ${var.imagepull_backoff_threshold_critical}"
  message = "Please take a look why {{pod_name}} is ImagePullBackOff in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_imagepull_backoff_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.imagepull_backoff_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# network send error monitor
resource "datadog_monitor" "network_tx_error_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Network Send errors high"
  count   = var.network_tx_error_enabled ? 1 : 0
  type    = "metric alert"
  query   = "avg(last_10m):avg:kubernetes.network.tx_errors{*${local.focus_network_tx_error_monitor}} by {cluster_name,kube_namespace,pod_name,kube_service} >= ${var.network_tx_error_threshold_critical}"
  message = "Please take a look why network TX (receive) errors occurring 100 times per second on {{pod_name}} in {{cluster_name}}. Notify: ${local.notify_network_tx_error_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.network_rx_error_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# network receive error monitor
resource "datadog_monitor" "network_rx_error_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Network Receive errors high"
  count   = var.network_rx_error_enabled ? 1 : 0
  type    = "metric alert"
  query   = "avg(last_10m):avg:kubernetes.network.rx_errors{*${local.focus_network_rx_error_monitor}} by {cluster_name,kube_namespace,pod_name,kube_service} >= ${var.network_rx_error_threshold_critical}"
  message = "Please take a look why network TX (receive) errors occurring 100 times per second on {{pod_name}} in {{cluster_name}}. Notify: ${local.notify_network_rx_error_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.network_rx_error_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# cpu monitor for eks pods
resource "datadog_monitor" "pod_cpu_usage_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod CPU is high"
  count   = var.pod_cpu_usage_enabled ? 1 : 0
  type    = "metric alert"
  query   = "min(last_10m):avg:kubernetes.cpu.usage.total{pod_name:${local.pod_name}${local.focus_pod_cpu_usage_monitor}} by {pod_name,kube_namespace,cluster_name}.fill(zero) >= ${var.pod_cpu_usage_threshold_critical}"
  message = "Please take a look why CPU is high on {{pod_name}} in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_pod_cpu_usage_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_cpu_usage_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# memory monitor for eks pods
resource "datadog_monitor" "pod_memory_usage_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod MEMORY is high"
  count   = var.pod_memory_usage_enabled ? 1 : 0
  type    = "metric alert"
  query   = "min(last_10m):avg:kubernetes.memory.usage{pod_name:${local.pod_name}${local.focus_pod_memory_usage_monitor}} by {pod_name,kube_namespace,cluster_name}.fill(zero) >= ${var.pod_memory_usage_threshold_critical}"
  message = "Please take a look why MEMORY is high on {{pod_name}} in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_pod_memory_usage_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_memory_usage_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# pending monitor for eks pods
resource "datadog_monitor" "pod_pending_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod is in PENDING status"
  count   = var.pod_pending_enabled ? 1 : 0
  type    = "metric alert"
  query   = "min(last_30m):sum:kubernetes_state.pod.status_phase{phase:running${local.focus_pod_pending_monitor}} by {cluster_name,kube_namespace} - sum:kubernetes_state.pod.status_phase{phase:running${local.focus_pod_pending_monitor}} by {cluster_name,kube_namespace} + sum:kubernetes_state.pod.status_phase{phase:pending${local.focus_pod_pending_monitor}} by {cluster_name,kube_namespace}.fill(zero) >= ${var.pod_pending_threshold_critical}"
  message = "Please take a look why {{pod_name}} is pending in {{kube_namespace}} on {{cluster_name}}. There are currently ({{value}}) pods Pending. Notify: ${local.notify_pod_pending_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_pending_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# terminated monitor for eks pods
resource "datadog_monitor" "pod_terminated_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod is in TERMINATED status"
  count   = var.pod_terminated_enabled ? 1 : 0
  type    = "metric alert"
  query   = "min(last_5m):avg:kubernetes_state.container.terminated{pod_name:${local.pod_name}${local.focus_pod_terminated_monitor}} by {pod_name,cluster_name,kube_namespace}.fill(zero) >= ${var.pod_terminated_threshold_critical}"
  message = "Please take a look why {{pod_name}} was terminated in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_pod_terminated_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_terminated_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}

# crash monitor for eks pods
resource "datadog_monitor" "pod_crash_monitor" {
  name    = "EKS [${var.env}] - [${var.app_name}] - Pod is crashing"
  count   = var.pod_crash_enabled ? 1 : 0
  type    = "metric alert"
  query   = "avg(last_5m):avg:kubernetes_state.container.restarts{pod_name:${local.pod_name}${local.focus_pod_crash_monitor}} - hour_before(avg:kubernetes_state.container.restarts{*} by {cluster_name,kube_namespace,pod_name}) > ${var.pod_crash_threshold_critical}"
  message = "Please take a look why {{pod_name}} has crashed repeatedly over the last hour in {{kube_namespace}} on {{cluster_name}}. Notify: ${local.notify_pod_crash_monitor}"
  tags    = local.tags

  monitor_thresholds {
    critical = var.pod_crash_threshold_critical
  }

  notify_audit        = true
  timeout_h           = 0
  new_group_delay     = var.new_group_delay
  include_tags        = true
  notify_no_data      = var.notify_no_data
  require_full_window = var.require_full_window
  renotify_interval   = 0
  escalation_message  = ""
  no_data_timeframe   = null
  evaluation_delay    = var.evaluation_delay
}
