provider "azurerm" {
  features {}
}

module "az_data_factory" {
  source = "../../modules/az/adf"
  // RG
  resource_group_name = "devops-challenge-rg"
  location            = "West Europe"
  
  // ADF
  name                = "devops-challenge-adf-01"
}

module "az_mssql_server_database" {
  source = "../../modules/az/mssql"

  // RG
  resource_group_name = "devops-challenge-rg"
  location            = "West Europe"

  // MSSQL Server
  mssql_server_name = "devops-challenge-mssql-server-01"
  mssql_server_administrator_login = "devops-challenge-login"
  mssql_server_administrator_login_password = "DEVopsCh@ll3nge"

  // MSSQL Database
  mssql_database_name = "devops-challenge-mssql-database-01"
  mssql_database_max_size_gb = 4
  mssql_database_sku_name = "S0"
}