resource "azurerm_resource_group" "azure_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "azure_mssql_server" {
  name                         = var.mssql_server_name // "example-sqlserver"
  resource_group_name          = azurerm_resource_group.azure_rg.name
  location                     = azurerm_resource_group.azure_rg.location
  version                      = var.mssql_server_version // "12.0"
  administrator_login          = var.mssql_server_administrator_login // "4dm1n157r470r"
  administrator_login_password = var.mssql_server_administrator_login_password // "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "azure_mssql_database" {
  name           = var.mssql_database_name // "acctest-db-d"
  server_id      = azurerm_mssql_server.azure_mssql_server.id
  collation      = var.mssql_database_collation  //"SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.mssql_database_max_size_gb // 4
  read_scale     = var.mssql_database_read_scale // true
  sku_name       = var.mssql_database_sku_name // "S0"

  tags = {
    Region            = azurerm_resource_group.azure_rg.location
    Team              = var.team_tag
    Environment       = var.env
    Creator           = var.creator
  }
}