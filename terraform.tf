variable "user_name" {}
variable "password" {}
variable "domain_name" {}
variable "tenant_name" {}
variable "region" {}
variable "auth_url" {}

// ========================
// Provider related section
// ========================
// Note: Tenant = Project in the console

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

// ==================================
// First create a new virtual network
// ==================================

resource "huaweicloudstack_networking_network_v2" "tfpoc-vnet" {
  name = "tfpoc-vnet"
  admin_state_up = "true"
}

// ================
// Then the subnets
// ================

// Private subnet
resource "huaweicloudstack_networking_subnet_v2" "tfpoc-private-subnet" {
  name = "tfpoc-private"
  network_id = huaweicloudstack_networking_network_v2.tfpoc-vnet.id
  cidr = "10.1.1.0/24"
  ip_version = 4
}

// Public subnet
resource "huaweicloudstack_networking_subnet_v2" "tfpoc-public-subnet" {
  name = "tfpoc-public"
  network_id = huaweicloudstack_networking_network_v2.tfpoc-vnet.id
  cidr = "10.1.2.0/24"
  ip_version = 4
}

// =======================
// Network security groups
// =======================

// Create a network security group for the PRIVATE subnet and add some rules
resource "huaweicloudstack_networking_secgroup_v2" "tfpoc-priv-secgroup" {
  description = "The security group for the private subnet"
  name = "tfpoc-priv-secgroup"
}

// Inbound rule allowing ICMP traffic from the public subnet
resource "huaweicloudstack_networking_secgroup_rule_v2" "ingress_icmp" {
  direction = "ingress"
  ethertype = "IPv4"
  port_range_max = 0
  port_range_min = 0  
  protocol = "icmp"
  remote_ip_prefix = "10.1.2.0/24"
  security_group_id = huaweicloudstack_networking_secgroup_v2.tfpoc-priv-secgroup.id
}

// Inbound rule allowing ssh traffic from the public subnet
resource "huaweicloudstack_networking_secgroup_rule_v2" "priv-ingress_ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  port_range_max = 22
  port_range_min = 22
  protocol = "tcp"
  remote_ip_prefix = "10.1.2.0/24"
  security_group_id = huaweicloudstack_networking_secgroup_v2.tfpoc-priv-secgroup.id
}

// Create a network security group for the PUBLIC subnet and add some rules
resource "huaweicloudstack_networking_secgroup_v2" "tfpoc-pub-secgroup" {
  description = "The security group for the public subnet"
  name = "tfpoc-pub-secgroup"
}

// Inbound rule allowing ssh traffic from the internet
// Replace the remote_ip_prefix with your own IP address
resource "huaweicloudstack_networking_secgroup_rule_v2" "pub-ingress_ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  port_range_max = 22
  port_range_min = 22
  protocol = "tcp"
  remote_ip_prefix = "185.6.233.179/32"
  security_group_id = huaweicloudstack_networking_secgroup_v2.tfpoc-pub-secgroup.id
}

// =============================================
// Create two VMS, one in public, one in private
// =============================================

// To be continued