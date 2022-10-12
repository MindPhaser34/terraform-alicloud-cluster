provider "alicloud" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12"

  backend "oss" {
    bucket = "new-project"
    prefix = "tf-state"
    key   = "terraform.tfstate"
    region = "us-west-1"
    endpoint = "https://example-oss-name.aliyuncs.com"
  }

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
    }
  }
}

// Here you could spec already exist ssh-key pair
data "alicloud_ecs_key_pairs" "default" {
  name_regex = "default-ssh-key"
}

// Configuration of Kubernetes cluster
resource "alicloud_cs_managed_kubernetes" "new-project" {
  count                 = 1
  name                  = var.k8s_name_prefix
  new_nat_gateway       = var.new_vpc == true ? false : var.new_nat_gateway
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  version               = var.kubernetes_version
  resource_group_id     = var.resource_group
  cluster_spec          = "ack.pro.small"
  worker_vswitch_ids    = length(var.vswitch_ids) > 0 ? var.vswitch_ids : alicloud_vswitch.new-project.*.id
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
  depends_on = [alicloud_snat_entry.new-project]
}

// Configuration of default node pool
resource "alicloud_cs_kubernetes_node_pool" "new-project" {
  name                  = "default"
  cluster_id            = alicloud_cs_managed_kubernetes.new-project.0.id
  image_type            = "AliyunLinux"
  vswitch_ids           = length(var.vswitch_ids) > 0 ? var.vswitch_ids : alicloud_vswitch.new-project.*.id
  instance_types        = var.worker_instance_types
  system_disk_category  = var.worker_disk_category
  system_disk_size      = var.worker_disk_size
  instance_charge_type  = "PostPaid"
  key_name              = data.alicloud_ecs_key_pairs.default.pairs.0.id
  install_cloud_monitor = true
  runtime_name          = var.runtime_name
  runtime_version       = var.runtime_version

  scaling_config {
    min_size = 1
    max_size = 10
  }

}
