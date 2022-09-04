variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "West Europe"
}

variable "name" {
  description = "(Required) Specifies the name of the Data Factory. Changing this forces a new resource to be created. Must be globally unique."
  type        = string
}

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