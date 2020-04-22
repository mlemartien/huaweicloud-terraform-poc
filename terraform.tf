variable "user_name" {}
variable "password" {}
variable "domain_name" {}
variable "tenant_name" {}
variable "region" {}
variable "auth_url" {}

// data "huaweicloudstack_images_image_v2" "centos" {
//   name = "CentOS7.4"
//   visibility  = "public"
//   most_recent = true
// }

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

// =============================================
// Create two VMS, one in public, one in private
// =============================================

// Create a key pair
// resource "huaweicloudstack_compute_keypair_v2" "tfpoc-keypair" {
//   name       = "tfpoc-keypair"
//   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN1PO/WS/6Apm+tB6geuaSaNkrnYIJOH/g1CH1mFHjlhlEUTSZOWvoyW4r/rlQVHsE21WMHdYJBViSFOtqIlxc/YBBf912rOjS/WSm/FGj38m/tD18BMZ5I/oMxKHLdd6/nZatMYBAhJNTKTzEcV59W5l5fyiJ4AahwZlH8CuhrvdWsm+bHfxB++OUlSk5kTy+uVB0ORcXaRIHfhux+4d66gasqo10hfv63kVNCq/MBrfi+aR0xPWI0ahG4JqYHIX4Mxq8PBMzSZE8k/rfUaThFQEEh0wfT3IB6uXxFtwmzlQjvzrx3K8MX3mkcSbUDvN9PmzXwuH23+KMDA0aKrHhOpIAPcIVoosvsCZfV542RyC76eu9RbWip5z7a/6B/fdi8VBBuL/R2K5bkMkGjyUVMDbySVyPc4umV6TLtwzLJHCpj4AZdAJh8x10arObGqQBUEU+tcGo/aZ9ChapFDAOokqzuLKwGTU9uLN/x/puRBA2W0oPJ/Q0OZ7ayjS0HSDQCIQG+AZai8f2yXSlNMlkDtxIjG2y5kHEKw2QqPqpyn2fhBu9btso8XC+FIdDA/+lavwCpxX07jJgLo7cvabWmDIpkoxOYf48RFuFalB3TKR0ZVw4hfRB0TxmP2ZFfEZhf/QeHeqP1SUuSHKeebvj4ic2EzZgsZDN29MmNegeOw== jacques@irim.com"
// }

// resource "huaweicloudstack_compute_instance_v2" "tfpoc-pub-vm" {
//   name              = "basic"
//   image_id          = "50abbd76-7c58-42ce-ae42-09ed77298fcc"
//   flavor_id         = "3"
//   //key_pair          = "my_key_pair_name"
//   //security_groups   = ["default"]
//   //availability_zone = "az"

//   metadata = {
//     Environment = "Test"
//   }

//   network {
//     uuid = huaweicloudstack_networking_network_v2.tfpoc-vnet.id
//   }
// }


// To be continued
