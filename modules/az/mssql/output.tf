output "az_mssql_server_id" {
  description = "The ID of the Data Factory."
  value       = azurerm_mssql_server.azure_mssql_server.id
}

output "az_mssql_database_id" {
  description = "The ID of the Azure MSSQL."
  value       = azurerm_mssql_database.azure_mssql_database.id
}
