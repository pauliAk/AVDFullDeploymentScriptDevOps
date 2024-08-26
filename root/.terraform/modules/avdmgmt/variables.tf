variable "resource_group_location" {
default     = "westeurope"
description = "Location of the resource group."
}

variable "rg_name" {
type        = string
#default     = "FeenixRG"
description = "Name of the Resource group in which to deploy service objects"
}

variable "workspace" {
type        = string
description = "Name of the Azure Virtual Desktop workspace"
default     = "FeenixWorkSpace"
}

variable "hostpool" {
type        = string
#default = "FeenixHP"
description = "Name of the Azure Virtual Desktop host pool"

}

variable "rfc3339" {
type        = string
default     = "2024-08-30T12:43:13Z"
description = "Registration token expiration"
}

variable "prefix" {
type        = string
default     = "avdtf"
description = "Prefix of the name of the AVD machine(s)"
}