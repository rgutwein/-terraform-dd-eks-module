terraform {
  required_providers {
    datadog = {
      source = "datadog/datadog"
    }
  }
  required_version = ">= 1.2.1"
}

provider "datadog" {
  api_url = "https://api.ddog-gov.com/"
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
