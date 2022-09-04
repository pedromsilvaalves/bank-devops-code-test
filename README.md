# DevOps Challenge

## Index

* [Instructions](#instructions)
* [Current Architecture](#current-architecture)
* [Current Diagram](#current-diagram)
* [Proposed Architecture](#proposed-architecture)
* [Terraform Plan](#terraform-plan-terratest)
* [CICD - Automation (Bonus)](#cicd-automation-bonus)
* [Observability (Bonus)](#observability-bonus)
* [Permissions (Bonus)](#permissions-bonus)
* [Best Practices (Bonus)](#best-practices-bonus)
* [Disaster Recovery Plan (Bonus)](#disaster-recovery-plan-bonus)
* [Compliance (Bonus)](#compliance-bonus)
* [Migration](#migration)
* [Budget (Bonus)](#budget-bonus)
* [Next Steps](#next-steps)

## Instructions

This challenge poses to test your experience on DevOps and the usual technologies applied.The most important thing for us is that you show your expertise and best practices.

Read the case specified in the Current Architecture section, and perform the steps described. We expect to see Terraform code to provision at least part of your proposed Architecture. We will consider favorably all bonus points you complete.

We have added some example modules to begin the migration into Azure. You may use them or delete them.

## Current Architecture

<details>
<summary><b>Test Details</b></summary>

---

Let’s imagine that a Bank has a monolithic architecture to handle the enrollment for new credit cards.
A potential customer will enter a bunch of data through some online forms.
Once a day there will be a batch processing job that will process all this
data. The job will trigger a monolithic application that extracts the day’s
data and run the following tasks.

• It will verify if it’s an existing customer and if it is, it will verify any
potential loans or red flags in case the customer is not eligible for a
new credit card.

• It will verify the customer’s identity. We reach an external API (e.g.
Equifax) to verify all the provided details are accurate and also verify
if there is any red flag.

• It will calculate the amount limit assigned for the credit card. It will
also auto-generate a new Credit Card number so the customer can
start using it right away until the actual credit card is received.

All the data is currently persisted on an on-premise Oracle DB. This DB
holds all the personal data the user inputs in the forms and also additional
data that will help to calculate his/her credit rating.

#### The Goal

As a company-wide initiative, we’ve been asked to

1. Migrate all our systems to a cloud provider (You may plan for AWS, Google Cloud or Azure)
2. The company is shifting to event-driven architecture with microservices

</details>

<details>
<summary><b>Tasks</b></summary>

#### The Test

This test will mix some designs (text and diagrams are expected) and
some coding. We are absolutely not aiming to build this system. We just
want to test some relevant points we’ll explicitly point out.

1. Given the 2 goals we mentioned in the previous section, imagine a
new architecture including text, diagrams, and any other useful
resource.
2. How are you going to handle the migration of data? Design a
strategy (maybe using cloud resources o anything else?) and tell us
about it.
3. Let’s assume the current DB is a traditional Oracle relational DB.
Write all the necessary scripts to migrate this data to a new DB in
the cloud. There are several options. Please explain which one you
choose and why.
4. (Bonus) Given the new architecture you designed let’s assume we’ll provision
new resources through Terraform. Build a small part of the most important
infrastructure with Terraform and build the plan for it.
5. (Bonus) What kind of monitoring would be relevant to add? What kind of
resources would be helpful to achieve this?
6. (Bonus) Give special attention how to handle exceptions if the job
stops for any reason. How do we recover? How will the deployment
process will be? Also, think about permissions, how are we giving the
cloud resources permissions?

We are expecting:

1. A detailed explanation for each step
2. The reasons to choose each resource in the cloud.
3. Details on how those resources work.

---
</details>

## FAQ

<details>
<summary>User / Permissions Migration</summary>

```
Are the users using auth/authentication federated service? SSO auth?

User’s apply through filling out forms without the necessity of creating an account with the bank (it is open to anyone)
so there should be no auth involved.
In the future we might incorporate federated auth that will allow us to fill out some information that we currently
request to users. So any prep work for the future would be great.
```
</details>

## Proposed Architecture

![alt text](/images/proposed_architecture.png "Proposed diagram")

The main requirements defined are the migration of the system to the cloud, and starting the re-architecture of the system to an event-driven architecture.

Follow the decisions to comply with the requirements:
The system is composed of:

* An *User Interface App* where the customer inserts data using online forms.
* An *Oracle database* where the data is stored.
* A *Monolithic application* that does the validation and calculations regarding the eligibility of the customer for a credit card.
* A *Batch Job* that runs once a day to start the processing of the data insert during the day.

There are refactors on this migration, but they aren't major ones, such as big changes to the products/architecture, like refactoring the monolithic application into three microservices, but some changes are made.

The On Premises Oracle DB is migrated to the Cloud using the Azure Data Factory.

* The Azure Data Factory can connect to the On-Prem DB using the Self Hosted Integration Runtime that can be installed on the host server.
* The network connectivity is achieved by using the Azure Express Route, connecting the Azure Network and On-Premises Network.
* By using Parametrized Datasets and Pipelines, we can migrate data from the Oracle DB to Azure SQL with little trouble.
* The prerequisite to this method is that the destine tables, inside the Azure SQL, have to already be created. So, before running the process, there is a need to analyze the tables inside the Oracle DB and re-create them inside Azure SQL.

It wasn`t specified how the User Inteface App(UI App) is making contact with the Database, but we can assume that it is done directly and in a synchronous way, so to reduce the coupling between the App and the DB, and removing the direct contact between the Customer-facing application and the DB, turning it more secure, there is a Storage Queue(Storage Account) between the UI App and the next step of the process.

The Batch Job was replaced with an Azure Function that reads messages sent by the UI App, having the job to do the first insertion of customer data into the database and publish an event on the InsertCustomerDataTopic where the Monolithic App is subscribed.

This is the first step in the event-driven architecture, where the applications run asynchronously and communicate with each other using messages or events.

## Requirements

* Azure with a Visual Studio Subscription
* Terraform => v0.12
* AZ cli --> (curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash)
* For Terratest --> Go v0.13

## Constrains

* Blob Storage for Terraform State
* Due to GDPR compliance we will store our data resources under in eu-west region

## Terraform plan / Terratest

Add Output of Terraform Plan
<details>
<summary>Summary</summary>

```text
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # module.az_data_factory.azurerm_data_factory.az_data_factory will be created
  + resource "azurerm_data_factory" "az_data_factory" {
      + id                     = (known after apply)
      + location               = "westeurope"
      + name                   = "devops-challenge-adf-01"
      + public_network_enabled = true
      + resource_group_name    = "devops-challenge-rg"
      + tags                   = {
          + "Creator"     = "pedromsilvaalves"
          + "Environment" = "dev"
          + "Region"      = "westeurope"
          + "Team"        = "DevOps"
        }
    }

  # module.az_data_factory.azurerm_resource_group.azure_rg will be created
  + resource "azurerm_resource_group" "azure_rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "devops-challenge-rg"
    }

  # module.az_mssql_server_database.azurerm_mssql_database.azure_mssql_database will be created
  + resource "azurerm_mssql_database" "azure_mssql_database" {
      + auto_pause_delay_in_minutes         = (known after apply)
      + collation                           = "SQL_Latin1_General_CP1_CI_AS"
      + create_mode                         = "Default"
      + creation_source_database_id         = (known after apply)
      + geo_backup_enabled                  = true
      + id                                  = (known after apply)
      + ledger_enabled                      = (known after apply)
      + license_type                        = "LicenseIncluded"
      + max_size_gb                         = 4
      + min_capacity                        = (known after apply)
      + name                                = "devops-challenge-mssql-database-01"
      + read_replica_count                  = (known after apply)
      + read_scale                          = true
      + restore_point_in_time               = (known after apply)
      + sample_name                         = (known after apply)
      + server_id                           = (known after apply)
      + sku_name                            = "S0"
      + storage_account_type                = "Geo"
      + tags                                = {
          + "Creator"     = "pedromsilvaalves"
          + "Environment" = "dev"
          + "Region"      = "westeurope"
          + "Team"        = "DevOps"
        }
      + transparent_data_encryption_enabled = true
      + zone_redundant                      = (known after apply)

      + long_term_retention_policy {
          + monthly_retention = (known after apply)
          + week_of_year      = (known after apply)
          + weekly_retention  = (known after apply)
          + yearly_retention  = (known after apply)
        }

      + short_term_retention_policy {
          + backup_interval_in_hours = (known after apply)
          + retention_days           = (known after apply)
        }

      + threat_detection_policy {
          + disabled_alerts            = (known after apply)
          + email_account_admins       = (known after apply)
          + email_addresses            = (known after apply)
          + retention_days             = (known after apply)
          + state                      = (known after apply)
          + storage_account_access_key = (sensitive value)
          + storage_endpoint           = (known after apply)
        }
    }

  # module.az_mssql_server_database.azurerm_mssql_server.azure_mssql_server will be created
  + resource "azurerm_mssql_server" "azure_mssql_server" {
      + administrator_login                  = "devops-challenge-login"
      + administrator_login_password         = (sensitive value)
      + connection_policy                    = "Default"
      + fully_qualified_domain_name          = (known after apply)
      + id                                   = (known after apply)
      + location                             = "westeurope"
      + minimum_tls_version                  = "1.2"
      + name                                 = "devops-challenge-mssql-server-01"
      + outbound_network_restriction_enabled = false
      + primary_user_assigned_identity_id    = (known after apply)
      + public_network_access_enabled        = true
      + resource_group_name                  = "devops-challenge-rg"
      + restorable_dropped_database_ids      = (known after apply)
      + version                              = "12.0"
    }

  # module.az_mssql_server_database.azurerm_resource_group.azure_rg will be created
  + resource "azurerm_resource_group" "azure_rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "devops-challenge-rg"
    }

Plan: 5 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

</details>

## Observability (Bonus)

What things will you consider?

```text
Example: Latency
```

<details>
<summary>Summary</summary>
  
Latency

* What: How long something takes to respond or complete
* Why: Direct impact on customer experience

</details>

## CICD Automation (Bonus)

Example:
Using a CI/CD we will automate the build and deploy processes. You can create multiple stages in the pipeline, each stage running based on the result of the previous one. 

## Permissions (Bonus)

Example:

![alt text](/images/example_permissions.png "Permissions")

## Best Practices (Bonus)

* Usage of private endpoints, to secure the connections between the resources.
* Usage of Managed Identities to control the roles and accesses of the resources, grating only what is needed.
* Usage of a Load Balancer for the UI App to help the scale.

## Disaster Recovery Plan (Bonus)

Example:

* Database Backup

## Compliance (Bonus)

* GDPR (data layer stored in EU-WEST)

## Migration

![alt text](https://cdn-images-1.medium.com/max/1600/0*WW36nabYAh5wn2v3. "Migration").

### What Migration Strategy would you choose?

The Migration Strategy for the App is going to be **Refactoring**, as we are changing bits and pieces of how the applications work, together with modifications to the architectural design.

The Migration Strategy for the Database is going to be **Replatforming**, as we are changing the platform and SGBD where the data is going to be hosted.

## App Migration Plan

1. Based on the redesigned architecture, create the new infrastructure needed for this migration into the Azure Cloud.
2. Refactor the UI App to instead of inputting the data directly to the Database, generate a message on the Queue *InsertCustomerDataQueue*.
3. Create an Azure Function based on the Batch Job that reads the *InsertCustomerDataQueue*, inserts the data into the Azure SQL database, and generates an event into the topic *InsertCustomerDataTopic*.
4. Refactor the Monolithic App to subscribe to the *InsertCustomerDataTopic*, so that the validation and calculation steps are triggered by it.
5. Refactor the Monolithic App to use Azure SQL instead of using Oracle DB.
6. Validate those integrations are running and working.
7. For the transition to the new App, we are going to change the DNS address from the old UI App to the new one available on Azure.
8. This transition needs to be done in a maintenance window so that we don't lose customer data in the process.
9. During the transition process we insert a mocked customer data into the App UI and wait for it to be processed.
10. If everything goes well, we can fully migrate, if not, we change the DNS to the old UI App.
11. We clean up the mocked data from the database, and for the Go Live we do the Database Migration.
12. After the Database Migration, end the maintenance window and go live.

## Database Migration Plan

1. Based on the redesigned architecture, create the new infrastructure needed for this migration into the Azure Cloud.
2. To prepare for the Database Migration, we recreate the tables present on the Oracle DB into the Azure SQL.
3. Install the Self Hosted Integration Runtime into the host server of the Oracle DB.
4. Configure the connections to the databases, both Oracle DB and Azure SQL, into Azure Data Factory.
5. Create parametrized datasets for both databases, so there isn't a need to create one for each table.
6. Create a parametrized pipeline so that we can use it for all the tables, instead of creating one "Copy data" action for each table.
7. Validate the data migration in QA first, using the QA environment of both On-Premises and Azure Cloud.
8. With the pipeline configuration validated, we recreate those configurations in Prod.
9. In a low volume moment of the day, test the data migration.
10. With everything set and done, wait until the **Step 11** of the App Migration Plan, and do the full migration of the data to Azure.

## Budget (Bonus)

Calculation Report

# Next Steps

## Anything that we need to consider in the future?

1. As the number of clients increase, the scalability of the application can become a issue, so one proposition is to refactor the application to take advantage of serverless computing to reduce costs and scale with ease.

* Proposed Future Architecture:

![alt text](/images/proposed_future_architecture.png "Proposed Future Architecture").
