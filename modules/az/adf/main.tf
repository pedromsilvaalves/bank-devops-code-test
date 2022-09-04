resource "azurerm_resource_group" "azure_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "az_data_factory" {
  name                = var.name
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name

  tags = {
    Region            = azurerm_resource_group.azure_rg.location
    Team              = var.team_tag
    Environment       = var.env
    Creator           = var.creator
  }
}