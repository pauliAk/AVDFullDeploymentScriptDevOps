/* output "azure_virtual_desktop_compute_resource_group" {
  description = "Name of the Resource group in which to deploy session host"
  value       = azurerm_resource_group.sh.name
}
 */
output "azure_virtual_desktop_host_pool" {
  description = "Name of the Azure Virtual Desktop host pool"
  # value       = azurerm_virtual_desktop_host_pool.hostpool.name
  value       = data.azurerm_virtual_desktop_host_pool.example.name
}

/* output "azurerm_virtual_desktop_application_group_dag" {
  
value = azurerm_virtual_desktop_application_group.dag

}

output "azurerm_virtual_desktop_application_group" {
  description = "Name of the Azure Virtual Desktop DAG"
  value       = azurerm_virtual_desktop_application_group.dag.name
} */

# output "azurerm_virtual_desktop_workspace" {
#   description = "Name of the Azure Virtual Desktop workspace"
#   value       = azurerm_virtual_desktop_workspace.workspace.name
# }

/* 
output "id" {
  value = data.azurerm_virtual_desktop_workspace.example.id
} 
 */


/* output "location" {
  description = "The Azure region"
  value       = azurerm_resource_group.sh.location
}
 */
/* output "AVD_user_groupname" {
  description = "Azure Active Directory Group for AVD users"
  value       = azuread_group.aad_group.display_name
} */

output "regtoken" {
value = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo 
}