# terraform-alicloud-cluster
Here is a simple example of terraform script to deploy **Kubernetes cluster on Alibaba Cloud** in `us-west-1` region with ACK Pro type, VPC configuration, default node pool, etc. 

Don't forget configure your access keys first!

```
export ALICLOUD_ACCESS_KEY=
export ALICLOUD_SECRET_KEY=
export ALICLOUD_REGION=us-west-1
```

Useful links:
- https://registry.terraform.io/providers/aliyun/alicloud/latest/docs
- https://github.com/terraform-alicloud-modules/terraform-alicloud-managed-kubernetes
- https://www.alibabacloud.com/help/en/container-service-for-kubernetes/latest/use-terraform-to-create-a-managed-kubernetes-cluster
- https://www.alibabacloud.com/help/en/elastic-compute-service/latest/terraform-overview