 variable "resource_group_location" {
  type = string
  # default     = "westeurope"
   default     = "westeurope"
  description = "Location of the resource group."
}
 
variable "rg_name" {
  type        = string
  #default     = "kun"
  description = "Name of the Resource group in which to deploy service objects"
}
/* 
variable "rg_shared_name" {
  type        = string
  # default     = "rg-shared-resources"
  description = "Name of the Resource group in which to deploy shared resources"
} */

variable "deploy_location" {
  type        = string
   #default     = "westeurope"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "AVDVnet" {
  type        = string
  default     = "kun"
  description = "Name of vnet existing hostpools are joined to"
}
variable "ad_vnet" {
  type        = string
  default     = "aadds-vnet"
  description = "Name of domain controller vnet"
}

variable "ad_rg" {
  type = string
  default = "AkAaddsRg"
}

variable "dns_servers" {
  type        = list(string)
  default     = ["10.1.0.4", "10.1.0.5"]
  description = "Custom DNS configuration"
}

variable "vnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/16"]
  description = "Address range for deployment VNet"
}

##newly added

variable "subnet_name" {
   type     = string
   default      = "internal"
    description = "subnet to host the session host subnet"
}

#####

/* variable "subnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/24"]
  description = "Address range for session host subnet"
}

variable "prefix" {
  type        = string
  # default     = "avdtf"
  description = "Prefix of the name of the AVD machine(s)"
} */