module "test_eks_monitor" {
  source              = "[SOURCE_URL]"
  env                 = "dev"
  cluster_name        = "dev-cluster"
  app_name            = "loki"
  tag_contact         = "user@example.com"
  tag_repo            = "[REPO_URL]"
  tag_domain          = "Test Management"
  notify_no_data      = false
  require_full_window = true
  notify_default_list = ["@slack-makebelieve-dd-monitors-channel"]
  # example on how to use the focus vars to look at multiple clusters etc
  focus_logs                   = "cluster_name:*"
  focus_monitors               = ",cluster_name:*"
  focus_node_ready             = "*"
  network_rx_error_enabled     = true
  network_tx_error_enabled     = true
  crashloop_backoff_enabled    = true
  imagepull_backoff_enabled    = true
  node_status_enabled          = true
  node_ready_enabled           = true
  deployment_status_enabled    = true
  statefulset_status_enabled   = true
  daemonset_status_enabled     = true
  pod_cpu_usage_enabled        = true
  pod_memory_usage_enabled     = true
  pod_pending_enabled          = true
  notify_pod_pending_monitor   = ["@slack-makebelieve-dd-monitors-channel", "@user@example.com"]
  pod_terminated_enabled       = true
  focus_pod_terminated_monitor = ", !pod_name:datadog*, pod_name:goldilocks*"
  pod_crash_enabled            = true
  pod_logs_enabled             = true
}

variable "datadog_api_key" {}
variable "datadog_app_key" {}
