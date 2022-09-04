// Resource Group
variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "West Europe"
}

// MSSQL Server

variable "mssql_server_name" {
  description = "(Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
  type = string
}

variable "mssql_server_version" {
  description = "(Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  type = string
  default = "12.0"
}

variable "mssql_server_administrator_login" {
  description = "(Optional) The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created."
}

variable "mssql_server_administrator_login_password" {
  description = "(Optional) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy. Required unless azuread_authentication_only in the azuread_administrator block is true."
}

// MSSQL Database

variable "mssql_database_name" {
  description = "(Required) The name of the MS SQL Database. Changing this forces a new resource to be created."
  type        = string
}

variable "mssql_database_collation" {
  type = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "mssql_database_max_size_gb" {
  type = number
  default = 4
}

variable "mssql_database_read_scale" {
  type = bool
  default = true
}

variable "mssql_database_sku_name" {
  type = string
  default = "S0"
}

// Tags

variable "env" {
  description = "(Optional) name of the resource group"
  default     = "dev"
}

variable "team_tag" {
  description = "(Optional) tag a team"
  default     = "DevOps"
}

variable "creator" {
  description = "(Optional) tag a creator"
  default     = "pedromsilvaalves"
}