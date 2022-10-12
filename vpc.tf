// Instance_types data source for instance_type
data "alicloud_instance_types" "new-project" {
  cpu_core_count = var.cpu_core_count
  memory_size    = var.memory_size
}

// Zones data source for availability_zone
data "alicloud_zones" "new-project" {
  available_instance_type = data.alicloud_instance_types.new-project.ids[0]
}

// If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "new-project" {
  count      = var.new_vpc == true ? 1 : 0
  cidr_block = var.vpc_cidr
  vpc_name     = "${var.k8s_name_prefix}-vpc"
}

// According to the vswitch cidr blocks to launch several vswitches
resource "alicloud_vswitch" "new-project" {
  count             = var.new_vpc == true ? length(var.vswitch_cidrs) : 0
  vpc_id            = concat(alicloud_vpc.new-project.*.id, [""])[0]
  cidr_block        = var.vswitch_cidrs[count.index]
  zone_id           = length(var.availability_zones) > 0 ? element(var.availability_zones, count.index) : element(data.alicloud_zones.new-project.ids.*, count.index)
  vswitch_name      =  var.k8s_name_prefix
}

resource "alicloud_nat_gateway" "new-project" {
  count       = var.new_vpc == true ? 1 : 0
  vpc_id      = concat(alicloud_vpc.new-project.*.id, [""])[0]
  name        = var.k8s_name_prefix
  nat_type    = var.nat_type
  payment_type  = var.payment_type
  vswitch_id  = alicloud_vswitch.new-project[count.index].id
  depends_on       = [alicloud_vswitch.new-project] 
}

resource "alicloud_eip" "new-project" {
  count         = var.new_vpc == true ? 1 : 0
  bandwidth     = var.new_eip_bandwidth
  address_name  = var.k8s_name_prefix
}

resource "alicloud_eip_association" "new-project" {
  count         = var.new_vpc == true ? 1 : 0
  allocation_id = concat(alicloud_eip.new-project.*.id, [""])[0]
  instance_id   = concat(alicloud_nat_gateway.new-project.*.id, [""])[0]
}

resource "alicloud_snat_entry" "new-project" {
  count             = var.new_vpc == true ? length(var.vswitch_cidrs) : 0
  snat_table_id     = concat(alicloud_nat_gateway.new-project.*.snat_table_ids, [""])[0]
  source_vswitch_id = alicloud_vswitch.new-project[count.index].id
  snat_ip           = concat(alicloud_eip.new-project.*.ip_address, [""])[0]
}