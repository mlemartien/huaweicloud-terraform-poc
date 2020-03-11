variable "user_name" {}
variable "password" {}
variable "domain_name" {}
variable "tenant_name" {}
variable "region" {}
variable "auth_url" {}

provider "huaweicloudstack" {
  user_name = var.user_name
  password = var.password
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  region = var.region
  auth_url = var.auth_url
  version = "~> 1.1"
  insecure = "true"
}

// First create a new network
resource "huaweicloudstack_networking_network_v2" "tfpoc-vpc" {
  name = "tfpoc-vpc"
  admin_state_up = "true"
}

// To be continued...