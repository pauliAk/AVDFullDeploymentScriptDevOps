
 data "azurerm_virtual_desktop_host_pool" "example" {
 
  name                = var.hostpool
  resource_group_name = var.rg_name
}
 


resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  
  hostpool_id     = data.azurerm_virtual_desktop_host_pool.example.id
  expiration_date = var.rfc3339
}

