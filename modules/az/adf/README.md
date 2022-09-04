# Terraform Azure Data Factory Module

Azure Data Factory Module

## Parameters to pass

| Parameters | Need | Description
| ------ | ------ | ------ |
source |(Required)|source of this module
name|(Required)|name of the Azure Data Factory
resource_group_name|(Required)|name of the Resorce Group
location|(Reqiured)|Location that will be deployed
env|(Optional)|name of the environment
team_tag|(Optional)|tag a team
creator|(Optional)|tag a creator

## Usage

```t

module "az_data_factory" {
  source = ""

  resource_group_name = "devops-challenge-rg"
  name                = "devops-challenge-adf-01"
  location            = "West Europe"
  env                 = "dev"
  team_tag            = "DevOps"
  creator             = "test"
}

```

### Terraform Execution

#### To initialize Terraform

```sh
terraform init
```

#### To execute Terraform Plan

```sh
terraform plan
```

#### To apply Terraform changes

```sh
terraform apply
```
