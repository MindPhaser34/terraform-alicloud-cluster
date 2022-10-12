//Autoscaling group
variable "region" {
  description = "(Deprecated from version 1.5.0)The region ID used to launch this module resources. If not set, it will be sourced from followed by ALICLOUD_REGION environment variable and profile."
  type        = string
  default     = "us-west-1"
}

variable "profile" {
  description = "(Deprecated from version 1.5.0)The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}

# VPC variables
variable "new_vpc" {
  description = "Create a new vpc for this module."
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc."
  type        = string
  default     = "10.0.0.0/8"
}

# VSwitch variables
variable "vswitch_ids" {
  description = "List Ids of existing vswitch."
  type        = list(string)
  default     = []
}

variable "vswitch_cidrs" {
  description = "List cidr blocks used to create several new vswitches when 'new_vpc' is true."
  type        = list(string)
  default     = ["10.10.10.0/24"]
}

variable "nat_type" {
  description = "The type of nat gateway. Valid values: [Normal, Enhanced]."
  type        = string
  default     = "Enhanced"
}

variable "payment_type" {
  description = "The type of nat gateway. Valid values: [Normal, Enhanced]."
  type        = string
  default     = "PayAsYouGo"
}

variable "availability_zones" {
  description = "List available zone ids used to create several new vswitches when 'vswitch_ids' is not specified. If not set, data source `alicloud_zones` will return one automatically."
  type        = list(string)
  default     = ["us-west-1a"]
}

variable "new_eip_bandwidth" {
  description = "The bandwidth used to create a new EIP when 'new_vpc' is true."
  type        = number
  default     = 100
}
variable "new_nat_gateway" {
  description = "Seting it to true can create a new nat gateway automatically in a existing VPC. If 'new_vpc' is true, it will be ignored."
  type        = bool
  default     = false
}
# Cluster nodes variables
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  type        = number
  default     = 4
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  type        = number
  default     = 16
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version"
  type        = string
  default     = "1.22.15-aliyun.1"
}

variable "resource_group" {
  description = "Resource group id"
  type        = string
  default     = ""
}

variable "runtime_name" {
  description = "Desired Kubernetes version"
  type        = string
  default     = "containerd"
}

variable "runtime_version" {
  description = "Desired Kubernetes version"
  type        = string
  default     = "1.5.13"
}

variable "worker_instance_types" {
  description = "The ecs instance type used to launch worker nodes. If not set, data source `alicloud_instance_types` will return one based on `cpu_core_count` and `memory_size`."
  type        = list(string)
  default     = ["ecs.g6.xlarge"]
}

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"
  type = list(object({
    name   = string
    config = string
  }))
  default = [
   {
     name   = "flannel",
     config = "",
   },
   {
     name   = "ack-node-problem-detector",
     config = "",
   },
   {
     name   = "alicloud-monitor-controller",
     config = "",
   },
   {
     name   = "metrics-server",
     config = "",
   },
   {
     name   = "csi-plugin",
     config = "",
   },
   {
     name   = "csi-provisioner",
     config = "",
   },
   {
     name   = "alicloud-disk-controller",
     config = "",
   },
   {
     name   = "logtail-ds",
     config = "{\"IngressDashboardEnabled\":\"true\"}",
   },
   {
     name     = "nginx-ingress-controller",
     config   = "",
     disabled: false,
   },
   {
     name   = "aliyun-acr-credential-helper",
     config = "",
   },
  ]
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  type        = string
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  type        = number
  default     = 100
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create managed kubernetes cluster."
  type        = string
  default     = "nodestack"
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`, it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX`."
  type        = string
  default     = "172.16.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. Its setting rule is same as `k8s_pod_cidr`."
  type        = string
  default     = "172.17.0.0/16"
}
