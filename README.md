# Datadog EKS Monitoring Module

This repo is for any Terraform modules associated with Datadog EKS monitoring.

## Minimum version of Terraform required to use this module

```
terraform {
  required_providers {
    datadog = {
      source = "datadog/datadog"
      version = "~> 3.14.0"
    }
  }
  required_version = ">= 0.13"
}
```

## Required Terraform values

Add the following blocks to your Terraform code especially the `api_url` otherwise it will default to https://api.datadoghq.com/ which we no longer use and give you an error of `Error: api_key and app_key must be set unless validate = false` which may make it confusing when troubleshooting since the `api_key` and `app_key` are necessary as well:

```
provider "datadog" {
  api_url = "https://api.ddog-gov.com/"
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
```

## Example instantiation of module

```
module "test_eks_monitor" {
  source                       = "github.com/department-of-veterans-affairs/terraform-dd-eks-module?ref=v0.0.3"
  env                          = "dev"
  cluster_name                 = "dsva-vagov-dev-cluster"
  app_name                     = "loki"
  tag_contact                  = "user@example.com"
  tag_repo                     = "https://github.com/department-of-veterans-affairs/terraform-dd-eks-module"
  tag_domain                   = "Test Management"
  notify_no_data               = false
  require_full_window          = true
  notify_default_list          = ["@slack-makebelieve-dd-monitors-channel"]
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
```

<sub>The K8s resource you're monitoring against can be set as the `app_name` var. This is unnecessary if you're using a monitor that's not specific to a particular pod, deployment, cluster etc. Also, confirm the `version` corresponds to an existing release tag [here](https://github.com/department-of-veterans-affairs/terraform-dd-eks-module/releases).</sub>

## Using module from GitHub Actions

To use the module from GitHub Actions, add the following blocks to your GitHub Actions' pipeline file (e.g. `workflows/ci.yaml`):
<sub>AWS Access / Secret keys and Terraform API / APP keys should be made available to GitHub Actions (e.g. GitHub environment variables) as `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. `TF_VAR_DATADOG_API_KEY`, and `TF_VAR_DATADOG_APP_KEY` respectively as well as the appropriate value for `TF_VERS`.</sub>

```
jobs:
  terraform_job:
    steps:
      - uses: actions/checkout@v2
      - uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: ${{ env.TF_VERS }}
      - uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-gov-west-1
      - run: |-
          cat > $TF_FOLDER/pipeline.auto.tfvars <<EOF
          datadog_api_key = "${{ secrets.TF_VAR_DATADOG_API_KEY }}"
          datadog_app_key = "${{ secrets.TF_VAR_DATADOG_APP_KEY }}"
          EOF
```

<sub>Have a look at `.github/workflows/ci.yaml` and `.github/actions/setup-tf-dd-aws/action.yaml` for further guidance in configuring your pipelines</sub>

## Tag All Monitors

Below, under the [Variables](#Variables) section, you'll find a number of tag vars that should be used for any and all monitors that are applied. _Please use them_.

## Available Monitors

The following are the monitors you can use against your EKS resources:

-   `pod_log_monitor` = Log monitor for EKS pods
-   `node_status_monitor` = Monitor for EKS nodes in unscheduled status
-   `node_ready_monitor` = Monitor for EKS nodes in not in ready status
-   `deployment_status_monitor` = Monitor for EKS deployments with down replica pods
-   `statefulset_status_monitor` = Monitor for EKS statefulsets with down replica pods
-   `statefulset_status_monitor` = Monitor for EKS daemonsets with down replica pods
-   `crashloop_backoff_monitor` = Monitor for EKS pods in CrashloopBackoff
-   `imagepull_backoff_monitor` = Monitor for EKS pods in ImagePullBackOff
-   `network_tx_error_monitor` = Monitor for EKS pods experiencing network send errors
-   `network_rx_error_monitor` = Monitor for EKS pods experiencing network receive errors
-   `pod_cpu_usage_monitor` = CPU monitor for EKS pods
-   `pod_memory_usage_monitor` = Memory monitor for EKS pods
-   `pod_pending_monitor` = Monitor for EKS pods in pending status
-   `pod_terminated_monitor` = Monitor for terminated EKS pods
-   `pod_crash_monitor` = Monitor for crashing EKS pods

## Variables

Vars for enabled monitors.

### App and Environment

-   `app_name` = The name of the app to be monitored. This is what will be used for deployment(s), daemonset(s), statefulset(s), and/or any resource that has a pod associated with it. If `*` is used, then the `Service` tag will default to `K8s Infra` since it's monitoring all deployments, daemonsets, statefulsets, pods, etc.
    -   `There is no default, this must be set`
-   `env` = The environment to be monitored
    -   `There is no default, this must be set. Common environments are 'dev', 'staging', 'utility', 'sandbox' or 'prod'; if the name of the cluster does not include the env then the focus vars are used instead.`

### Tagging

-   `tag_contact` = The team responsible for monitor
    -   `default = ""`
-   `tag_repo` = Identifier for repo where Terraform code lives
    -   `default = ""`
-   `tag_domain` = Identifier for service domain
    -   `default = ""`

### Logs

-   `pod_logs_enabled` = Flag to enable Pod Log monitor
    -   `default = false`
-   `pod_log_threshold_critical` = Critical threshold for the Pod Log monitor
    -   `default = 0`
-   `pod_log_query` = The value to alert on
    -   `default = status:(\\\"fatal\\\" OR \\\"fail*\\\" OR \\\"exception\\\" OR \\\"error\\\" OR \\\"warning\\\" OR \\\"timed out\\\" OR \\\"traceback\\\")`

### Network Errors

-   `network_rx_error_usage_enabled` = Flag to enable Network Receive Error monitor
    -   `default = false`
-   `network_rx_error_threshold_critical` = Critical threshold for the Network Receive Error monitor
    -   `default = 100`
-   `network_tx_error_usage_enabled` = Flag to enable Network Receive Error monitor
    -   `default = false`
-   `network_tx_error_threshold_critical` = Critical threshold for the Network Send Error monitor
    -   `default = 100`

### Crashloop Backoff Status

-   `crashloop_backoff_usage_enabled` = Flag to enable Crashloop Backoff Status monitor
    -   `default = false`
-   `crashloop_backoff_threshold_critical` = Critical threshold for the Crashloop Backoff monitor
    -   `default = 1`

### Image Pull Backoff Status

-   `imagepull_backoff_usage_enabled` = Flag to enable Image Pull Backoff Status monitor
    -   `default = false`
-   `imagepull_backoff_threshold_critical` = Critical threshold for the Image Pull Backoff Status monitor
    -   `default = 1`

### Node

-   `node_status_usage_enabled` = Flag to enable Node Status monitor
    -   `default = false`
-   `node_ready_usage_enabled` = Flag to enable Node Ready monitor
    -   `default = false`
-   `node_status_threshold_critical` = Critical threshold for the Node Status monitor
    -   `default = 80`
-   `node_ready_threshold_critical` = Critical threshold for the Node Ready monitor
    -   `default = 3`

### Deployment

-   `deployment_status_usage_enabled` = Flag to enable Deployment Status monitor
    -   `default = false`
-   `deployment_status_threshold_critical` = Critical threshold for the Deployment Status monitor
    -   `default = 1`

### Deployment

-   `deployment_status_usage_enabled` = Flag to enable Deployment Status monitor
    -   `default = false`
-   `deployment_status_threshold_critical` = Critical threshold for the Deployment Status monitor
    -   `default = 1`

### StatefulSet

-   `statefulset_status_usage_enabled` = Flag to enable StatefulSet Status monitor
    -   `default = false`
-   `statefulset_status_threshold_critical` = Critical threshold for the Deployment Status monitor
    -   `default = 1`

### DaemonSet

-   `daemonset_status_usage_enabled` = Flag to enable DaemonSet Status monitor
    -   `default = false`
-   `daemonset_status_threshold_critical` = Critical threshold for the Deployment Status monitor
    -   `default = 1`

### CPU

-   `pod_cpu_usage_enabled` = Flag to enable Pod CPU usage monitor
    -   `default = false`
-   `pod_cpu_usage_threshold_critical` = Critical threshold for the Pod CPU usage monitor
    -   `default = 6000000000`

### Memory

-   `pod_memory_usage_enabled` = Flag to enable Pod MEMORY usage monitor
    -   `default = false`
-   `pod_memory_usage_threshold_critical` = Critical threshold for the Pod MEMORY usage monitor
    -   `default = 4000000000`

### Pending pods

-   `pod_pending_enabled` = Flag to enable Pod Pending monitor
    -   `default = false`
-   `pod_pending_threshold_critical` = Critical threshold for the Pod Pending monitor
    -   `default = 1`

### Terminated pods

-   `pod_terminated_enabled` = Flag to enable Pod Terminated monitor
    -   `default = false`
-   `pod_terminated_threshold_critical` = Critical threshold for the Pod Terminated monitor
    -   `default = 1`

### Crashing pods

-   `pod_crash_enabled` = Flag to enable Pod Crash monitor
    -   `default = false`
-   `pod_crash_threshold_critical` = Critical threshold for the Pod Crash monitor
    -   `default = 0`

### Misc vars and locals

-   `pod_name` = The value that pod specific moditors will monitor
    -   `${var.app_name}*`
-   `focus_logs` = The value to include or exclude on for the `pod_log_monitor`. Be sure to use `-` in front of the facet/string to exclude or nothing in front of the facet/string to include; use a space to separate your include/exclude list
    -   `default = cluster_name:${var.env}`
-   `focus_logs_enabled` = Enable the use of `focus_logs`
    -   `default = false`
-   `focus_monitors` = The value to include or exclude on for all monitors except for the `pod_log_monitor`. Be sure to use `!` in front of the facet/string to exclude or nothing in front of the facet/string to include; use `,` to separate your include/exclude list
    -   `default = ,cluster_name:${var.env}`
-   `focus_monitors_enabled` = Enable the use of `focus_monitors`"
    -   `default = false`
-   `focus_node_ready` = The cluster name to monitor
    -   `default = ${var.env}-main-cluster`
-   `focus_node_ready_enabled` = Enable the use of `focus_node_ready`
    -   `default = false`
-   `notify_<name_of_monitor>` = This can be set to append further contacts to the `notify_default_list` (e.g. `@pageryduty`).
    -   `default = []`
-   `focus_<name_of_monitor>` = This can be set to include or exclude specific metrics (e.g. `, !pod_name:vault-snapshot-cronjob*`).
    -   `default = ""`
-   `tags` = Aggregates all tags
    -   `["Domain:${var.tag_domain}", "Service:${var.app_name == "*" ? "K8s Infra" : var.app_name}", "Contact:${var.tag_contact}", "Repo:${var.tag_repo}", "Environment: ${var.env}", "Managed:Terraform"]`
-   `notify_default_list` = Set this to where you'd like alerts to go (e.g. slack channel, email, etc).
    -   `default = []`
-   `evaluation_delay` = Delay in seconds for the metric evaluation
    -   `default = 900`
-   `new_host_delay` = Delay in seconds before monitor new resource
    -   `default = true`
-   `notify_no_data` = Will raise no data alert if set to true
    -   `default = true`

### Behavior of `focus` vars/locals

If `var.env` does not match a substring in `var.cluster_name` (e.g. `".*-${var.env}-.*"`) and `var.focus_*` is not set, the monitors will default to looking at all available clusters except for our gitlab cluster, `eks-use1-ss`.

### Examples

#### `monitors.tf`

```
module "test_eks_monitor" {
  source                       = "github.com/department-of-veterans-affairs/terraform-dd-eks-module"
  env                          = "dev"
  cluster_name                 = "dsva-vagov-dev-cluster"
  app_name                     = "loki"
  tag_contact                  = "user@example.com"
  tag_repo                     = "https://github.com/department-of-veterans-affairs/terraform-dd-eks-module"
  tag_domain                   = "Test Management"
  notify_no_data               = false
  require_full_window          = true
  notify_default_list          = ["@slack-makebelieve-dd-monitors-channel"]
  focus_logs                   = "cluster_name:dsva-vagov-dev-cluster" # we don't currently use dd logs heavily, but will keep this just in case
  focus_monitors               = ",cluster_name:dsva-vagov-dev-cluster"
  focus_node_ready             = "dsva-vagov-dev-cluster"
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
```

#### `variables.tf`

```
# Set in terraform/variables/common.vars
variable "pod_name" {
  default = "runner*"
}

# Datadog vars
variable "datadog_api_key" {}
variable "datadog_app_key" {}

# Notify Lists
variable "notify_default_list" {
  default = ["@slack-makebelieve-dd-monitors-channel"]
}
variable "notify_pod_pending_monitor" {
  default = ["@slack-makebelieve-dd-monitors-channel", "@user@example.com"]
}

# Tags
variable "tag_contact" {
  default = "user@example.com"
}
variable "tag_repo" {
  default = "https://github.com/department-of-veterans-affairs/terraform-dd-eks-module"
}
variable "tag_domain" {
  default = "Test Management"
}
```

#### `outputs.tf`

```
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
```

#### `remote_state.tf`

```
terraform {
  backend "s3" {
    bucket         = "dsva-shared-terraform-remote-state"
    dynamodb_table = "dsva-shared-terraform-lock"
    key            = "test_dd_eks_statefile"
    region         = "us-gov-west-1"
  }
}
```
