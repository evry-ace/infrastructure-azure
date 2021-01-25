# tf_aks_networkpolicies

This Terraform module enables Network Policies on Azure Kubernetes Service (AKS)
clusters.

## Usage

```terraform
module "bastion" {
  source                      = "github.com/terraform-community-modules/tf_aws_bastion_s3_keys"
  instance_type               = "t2.micro"
  ami                         = "ami-123456"
  region                      = "eu-west-1"
  iam_instance_profile        = "s3_readonly"
  s3_bucket_name              = "public-keys-demo-bucket"
  vpc_id                      = "vpc-123456"
  subnet_ids                  = ["subnet-123456", "subnet-6789123", "subnet-321321"]
  keys_update_frequency       = "5,20,35,50 * * * *"
  additional_user_data_script = "date"
}
```

### Inputs

*
*

### Outputs

*
*
