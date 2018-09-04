# ACE Infrastructure Automation for Azure

This repository contains Infrastrucutre as Code for runnong the ACE platform on
public Azure using HashiCorp Terraform.

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed.
* [Terraform](https://terraform.io/downloads.html) installed.

## Create Azure Client

Generate Azure Client ID and secret.

```bash
az ad sp create-for-rbac \
  --name="Kubernetes AKS Terraform" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

Expected output:

```bash
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "Kubernetes AKS Terraform",
  "name": "http://kubernetes-aks-terraform",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```

Create a new file inside the `/secrets` directory. The name of the file should
be on the following format `<cluster>.secrets.tfvars` where `<cluster>` is the
name of the new cluster.

```
subscription_id = "<subscription>"
client_id = "<appId>"
client_secret = "<password>"
tenant_id = "<tenant>"
```

## Create SSH Key

```
ssh-keygen -t rsa -b 4096 -C "<cluster>@<corp>.com"
```

The public part (the one ending in `.pub`) of this key should be added to the
`<cluster>.secrets.tfvars` file above like this:

```
ssh_public_key = "ssh-rsa ..."
```

## Terraform Init

Set up the Terraform backend with the required authentication settings that can
not be stored in a file.

```bash
terraform init \
  -backend-config="subscription_id=YOUR_SUBSCRIPTION_ID" \
  -backend-config="client_id=YOUR_CLIENT_ID" \
  -backend-config="client_secret=YOUR_CLIENT_SECRET" \
  -backend-config="tenant_id=YOUR_TENANT_ID"
```

## Terraform Plan

Replace `<cluster>` with the name of the cluster you want to change.

```bash
terraform plan \
  -var-file clusters/<cluster>.tfvars \
  -var-file secrets/<cluster>.secrets.tfvars
```

## Terraform Apply

Replace `<cluster>` with the name of the cluster you want to change.

```bash
terraform apply \
  -var-file clusters/<cluster>.tfvars \
  -var-file secrets/<cluster>.secrets.tfvars
```

*Note:* Creating an new Azure AKS cluster can take up to 15 minutes.

## Kubeconfig

Instructions can be obtained by running the following command

```bash
terraform output configure

Run the following commands to configure kubernetes client:

$ terraform output kube_config > ~/.kube/aksconfig
$ export KUBECONFIG=~/.kube/aksconfig

Test configuration using kubectl

$ kubectl get nodes
```

Save kubernetes config file to `~/.kube/aksconfig`

```bash
terraform output kube_config > ~/.kube/aksconfig
```

Set `KUBECONFIG` environment variable to the kubernetes config file

```bash
export KUBECONFIG=~/.kube/aksconfig
```

### Test Kubeconfig

```bash
kubectl get nodes
```

```bash
NAME                     STATUS    ROLES     AGE       VERSION
aks-default-75135322-0   Ready     agent     23m       v1.9.6
aks-default-75135322-1   Ready     agent     23m       v1.9.6
aks-default-75135322-2   Ready     agent     23m       v1.9.6
```
