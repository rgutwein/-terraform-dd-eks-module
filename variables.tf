# Required
variable "app_name" {
  description = "Name of app for deployment, statefulset, daemonset, etc"
  type        = string
}

variable "env" {
  description = "Name of Environment (e.g. dev, staging, utility, sandbox, or prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

# Misc
variable "focus_logs" {
  description = "The value to include or exclude on. Be sure to use '-' in front of the facet/string to exclude or nothing in front of the facet/string to include"
  type        = string
  default     = ""
}

variable "focus_monitors" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

variable "focus_node_ready" {
  description = "The cluster name to monitor."
  type        = string
  default     = ""
}

variable "notify_default_list" {
  description = "Default notify list"
  type        = list(string)
  default     = []
}
variable "evaluation_delay" {
  description = "Delay in seconds for the metric evaluation"
  type        = number
  default     = 0
}
variable "new_group_delay" {
  description = "Delay in seconds before monitor new groups"
  type        = number
  default     = 300
}
variable "notify_no_data" {
  description = "Will raise no data alert if set to true"
  type        = bool
  default     = true
}
variable "require_full_window" {
  description = "Whether or not to require a full window of data for evaluation."
  type        = bool
  default     = false
}

# Tags
variable "tag_contact" {
  description = "The team responsible for monitor"
  type        = string
  default     = ""
}
variable "tag_repo" {
  description = "Identifier for repo where TF code lives"
  type        = string
  default     = ""
}
variable "tag_domain" {
  description = "Identifier for service domain"
  type        = string
  default     = ""
}

# Logs
variable "pod_logs_enabled" {
  description = "Flag to enable Pod Log monitor"
  type        = bool
  default     = false
}
variable "notify_pod_log_monitor" {
  description = "Appends a list of contacts to a Pod Log monitor message"
  type        = list(string)
  default     = []
}
variable "pod_log_threshold_critical" {
  description = "Critical threshold for the Pod Log monitor"
  type        = number
  default     = 0
}
variable "pod_log_query" {
  description = "The value to alert on"
  type        = string
  default     = "status:(\\\"fatal\\\" OR \\\"fail*\\\" OR \\\"exception\\\" OR \\\"error\\\" OR \\\"warning\\\" OR \\\"timed out\\\" OR \\\"traceback\\\")"
}

# Node
variable "node_status_enabled" {
  description = "Flag to enable Node Status monitor"
  type        = bool
  default     = false
}
variable "node_status_threshold_critical" {
  description = "Critical threshold for the Node Status monitor"
  type        = number
  default     = 80
}
variable "notify_node_status_monitor" {
  description = "Appends a list of contacts to Node Status monitor message"
  type        = list(string)
  default     = []
}
variable "node_ready_enabled" {
  description = "Flag to enable Node Ready monitor"
  type        = bool
  default     = false
}
variable "node_ready_threshold_critical" {
  description = "Critical threshold for the Node Ready monitor"
  type        = number
  default     = 3
}
variable "notify_node_ready_monitor" {
  description = "Appends a list of contacts to Node Ready monitor message"
  type        = list(string)
  default     = []
}

# Deployment
variable "deployment_status_enabled" {
  description = "Flag to enable Deployment Status monitor"
  type        = bool
  default     = false
}
variable "deployment_status_threshold_critical" {
  description = "Critical threshold for the Deployment Status monitor"
  type        = number
  default     = 1
}
variable "notify_deployment_status_monitor" {
  description = "Appends a list of contacts to Deployment Status monitor message"
  type        = list(string)
  default     = []
}

variable "focus_deployment_status_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# StatefulSet
variable "statefulset_status_enabled" {
  description = "Flag to enable StatefulSet Status monitor"
  type        = bool
  default     = false
}
variable "statefulset_status_threshold_critical" {
  description = "Critical threshold for the StatefulSet Status monitor"
  type        = number
  default     = 1
}
variable "notify_statefulset_status_monitor" {
  description = "Appends a list of contacts to StatefulSet Status monitor message"
  type        = list(string)
  default     = []
}

variable "focus_statefulset_status_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# DaemonSet
variable "daemonset_status_enabled" {
  description = "Flag to enable DaemonSet Status monitor"
  type        = bool
  default     = false
}
variable "daemonset_status_threshold_critical" {
  description = "Critical threshold for the DaemonSet Status monitor"
  type        = number
  default     = 1
}
variable "notify_daemonset_status_monitor" {
  description = "Appends a list of contacts to DaemonSet Status monitor message"
  type        = list(string)
  default     = []
}

variable "focus_daemonset_status_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Crashloop Backoff Status
variable "crashloop_backoff_enabled" {
  description = "Flag to enable Crashloop Backoff Status monitor"
  type        = bool
  default     = false
}
variable "crashloop_backoff_threshold_critical" {
  description = "Critical threshold for the Crashloop Backoff Status monitor"
  type        = number
  default     = 1
}
variable "notify_crashloop_backoff_monitor" {
  description = "Appends a list of contacts to Crashloop Backoff Status message"
  type        = list(string)
  default     = []
}

variable "focus_crashloop_backoff_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Image Pull Backoff Status
variable "imagepull_backoff_enabled" {
  description = "Flag to enable Image Pull Backoff Status monitor"
  type        = bool
  default     = false
}
variable "imagepull_backoff_threshold_critical" {
  description = "Critical threshold for the Image Pull Backoff Status monitor"
  type        = number
  default     = 1
}
variable "notify_imagepull_backoff_monitor" {
  description = "Appends a list of contacts to Image Pull Backoff Status monitor message"
  type        = list(string)
  default     = []
}

variable "focus_imagepull_backoff_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Network Errors
variable "network_tx_error_enabled" {
  description = "Flag to enable Network Send Error monitor"
  type        = bool
  default     = false
}
variable "network_tx_error_threshold_critical" {
  description = "Critical threshold for the Network Send Error monitor"
  type        = number
  default     = 100
}
variable "notify_network_tx_error_monitor" {
  description = "Appends a list of contacts to Network Send Error monitor message"
  type        = list(string)
  default     = []
}
variable "focus_network_tx_error_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}
variable "network_rx_error_enabled" {
  description = "Flag to enable Network Receive Error monitor"
  type        = bool
  default     = false
}
variable "network_rx_error_threshold_critical" {
  description = "Critical threshold for the Network Receive Error monitor"
  type        = number
  default     = 100
}
variable "notify_network_rx_error_monitor" {
  description = "Appends a list of contacts to Network Receive Error monitor message"
  type        = list(string)
  default     = []
}
variable "focus_network_rx_error_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# CPU
variable "pod_cpu_usage_enabled" {
  description = "Flag to enable Pod CPU usage monitor"
  type        = bool
  default     = false
}
variable "notify_pod_cpu_usage_monitor" {
  description = "Appends a list of contacts to Pod CPU usage monitor message"
  type        = list(string)
  default     = []
}
variable "pod_cpu_usage_threshold_critical" {
  description = "Critical threshold for the Pod CPU usage monitor"
  type        = number
  default     = 6000000000
}
variable "focus_pod_cpu_usage_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Memory
variable "pod_memory_usage_enabled" {
  description = "Flag to enable Pod MEMORY usage monitor"
  type        = bool
  default     = false
}
variable "notify_pod_memory_usage_monitor" {
  description = "Appends a list of contacts to Pod MEMORY usage monitor message"
  type        = list(string)
  default     = []
}
variable "pod_memory_usage_threshold_critical" {
  description = "Critical threshold for the Pod MEMORY usage monitor"
  type        = number
  default     = 4000000000
}
variable "focus_pod_memory_usage_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Pending Pods
variable "pod_pending_enabled" {
  description = "Flag to enable Pod Pending monitor"
  type        = bool
  default     = false
}
variable "notify_pod_pending_monitor" {
  description = "Appends a list of contacts to Pod Pending monitor message"
  type        = list(string)
  default     = []
}
variable "pod_pending_threshold_critical" {
  description = "Critical threshold for the Pod Pending monitor"
  type        = number
  default     = 1
}
variable "focus_pod_pending_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Terminated Pods
variable "pod_terminated_enabled" {
  description = "Flag to enable Pod Terminated monitor"
  type        = bool
  default     = false
}
variable "notify_pod_terminated_monitor" {
  description = "Appends a list of contacts to Pod Terminated monitor message"
  type        = list(string)
  default     = []
}
variable "pod_terminated_threshold_critical" {
  description = "Critical threshold for the Pod Terminated monitor"
  type        = number
  default     = 1
}
variable "focus_pod_terminated_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}

# Crash Pods
variable "pod_crash_enabled" {
  description = "Flag to enable Pod Crash monitor"
  type        = bool
  default     = false
}
variable "notify_pod_crash_monitor" {
  description = "Appends a list of contacts to Pod Crash monitor message"
  type        = list(string)
  default     = []
}
variable "pod_crash_threshold_critical" {
  description = "Critical threshold for the Pod Crash monitor"
  type        = number
  default     = 3
}
variable "focus_pod_crash_monitor" {
  description = "The value to include or exclude on. Be sure to use '!' in front of the facet/string to exclude or nothing in front of the facet/string to include; use ',' to separate your include/exclude list"
  type        = string
  default     = ""
}
