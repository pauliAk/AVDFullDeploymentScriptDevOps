

data "azurerm_virtual_network" "example" {
  name                = var.AVDVnet
  resource_group_name = var.rg_name
  
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.example.id
}

data "azurerm_subnet" "example" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_virtual_network.example.resource_group_name
}

data "azurerm_virtual_network" "ad_vnet_data" {
  name                = var.ad_vnet
  resource_group_name = var.ad_rg

}
