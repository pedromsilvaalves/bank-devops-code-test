# Terraform Azure Data Factory Module

Azure Data Factory Module

## Parameters to pass

| Parameters | Need | Description
| ------ | ------ | ------ |
source |(Required)|source of this module
mssql_server_name|(Required)|MSSQL server name
mssql_server_version|(Required)|MSSQL server versio
mssql_server_administrator_login|(Required)|MSSQL server admin login
mssql_server_administrator_login_password|(Required)|MSSQL server admin password
mssql_database_name|(Required)|MSSQL Database name
mssql_database_collation|(Required)|MSSQL Database collation
mssql_database_max_size_gb|(Required)|MSSQL Database Max size(GB)
mssql_database_read_scale|(Required)|MSSQL Database Read Scale (bool)
mssql_database_sku_name|(Required)|MSSQL Database SKU name
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
