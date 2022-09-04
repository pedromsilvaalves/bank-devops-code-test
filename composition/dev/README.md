# How to use the Terraform code

Login and set the Azure subscription

```bash
az login  
az account set --subscription "<SUBSCRIPTION-ID>"
```

Create a Service Principal:

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
Creating 'Contributor' role assignment under scope '/subscriptions/<SUBSCRIPTION_ID>'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
  "displayName": "azure-cli-2022-xxxx",
  "password": "xxxxxx~xxxxxx~xxxxx",
  "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
}
```

Add environment variables

* For MacOS/Linux:

```bash
export ARM_CLIENT_ID="<SERVICE_PRINCIPAL_APPID>"
export ARM_CLIENT_SECRET="<SERVICE_PRINCIPAL_PASSWORD>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_ID>"
```

* For Windows (PowerShell):

```bash
$env:ARM_CLIENT_ID="<SERVICE_PRINCIPAL_APPID>"
$env:ARM_CLIENT_SECRET="<SERVICE_PRINCIPAL_PASSWORD>"
$env:ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
$env:ARM_TENANT_ID="<TENANT_ID>"
```

Run the Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

After the validation, destroy the infrastructure:

```bash
terraform destroy
```

References:
[alfonsof github azure tutorial](https://github.com/alfonsof/terraform-azure-examples/blob/master/code/01-hello-world/README.md)