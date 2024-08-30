 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
       version = "=3.44.1"
      
    }
    azuread = {
      source = "hashicorp/azuread"
    }
     random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
}

}
/*
data "external" "set-sub" {
  program = ["bash", "-c","az account set --name '761cc**************a5d6aa0fde41' -o json "]
} 
 */

/*  data "external" "client_secret" {
program = ["bash", "-c", "az keyvault secret show --vault-name 'kunkeyvault' --name 'client-secret' --query '{value: value}' -o json"]
}

data "external" "client_id" {
program = ["bash", "-c", "az keyvault secret show --vault-name 'kunkeyvault' --name 'client-id' --query '{value: value}' -o json"]
} */
 
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
 /*  #client_id = data.azurerm_key_vault_secret.client_id.value
  client_id = data.external.client_id.result["value"]
  #client_secret = data.azurerm_key_vault_secret.client_secret.value
  client_secret = data.external.client_secret.result["value"] */
  #tenant_id = var.tenant_id  
  use_msi = true

}

/* data "azurerm_key_vault" "keyvault" {
  name                = var.keyvaultname
  resource_group_name = var.keyvaultRG
}

output "vault_uri" {
  value = data.azurerm_key_vault.keyvault.vault_uri
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = var.client-secret
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

output "client_secret_value" {
  value     = data.azurerm_key_vault_secret.client_secret.value
  sensitive = true
}

data "azurerm_key_vault_secret" "client_id" {
  name         = var.client-id
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

output "client_id_value" {
  value     = data.azurerm_key_vault_secret.client_id.value
  sensitive = true
}
 */

data "azurerm_shared_image_version" "kun" {
  name                = "1.0.5"
  image_name          = "acgImageDef4"
  gallery_name        = "acgAk"
  resource_group_name = "kun"
} 

module avdmgmt {
source = "./desktop"
hostpool = "FeenixHP"
rg_name = "FeenixRG"

}

locals {
  registration_token = module.avdmgmt.regtoken.token
}


resource "random_string" "AVD_local_password" {
  count            = var.rdsh_count
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

module avdvnetAk {
source = "./networkSettings"

#prefix = "avdtf"
rg_name = "kun"
deploy_location = "west europe"

# resource_group_location = var.resource_group_location

# rg_shared_name = var.rg
}


resource "azurerm_network_interface" "avd_vm_nic" {
  count               = var.rdsh_count
  name                = "${var.prefix}-${count.index + 1}-nic"
  # resource_group_name = azurerm_resource_group.rg.name
  resource_group_name = module.avdvnetAk.rgroup
  location            = module.avdvnetAk.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = module.avdvnetAk.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    # azurerm_resource_group.rg
    module.avdvnetAk
  ]
}
resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                 = var.rdsh_count
  name                  = "${var.prefix}-${count.index + 1}"
  resource_group_name   = module.avdvnetAk.rgroup
  location              = module.avdvnetAk.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password
  source_image_id       = data.azurerm_shared_image_version.kun.id
  #source_image_id       = azurerm_shared_image_version.kun.id

   os_disk {
    #name                 = "${lower(var.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
       
    
   /*   source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-evd"
    version   = "latest" 
  } */
 
  depends_on = [
    module.avdvnetAk,
    azurerm_network_interface.avd_vm_nic,
    #module.imagegallery
    #module.imagegallery.Gallery_imageid
  ]
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}-${count.index + 1}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_user_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

/*   depends_on = [
    module.avdvnetAk.peering1,
    module.avdvnetAk.peering2
  ] */
}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]


  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${module.avdmgmt.azure_virtual_desktop_host_pool}"
       
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
PROTECTED_SETTINGS

lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.domain_join,
    # azurerm_virtual_desktop_host_pool.hostpool

    #since the resources in the modlue already existing and not being created afresh
    #commenting out the below(module.avdmgmt,) , as it is not a dependency
    # module.avdmgmt,


   # module.imagegallery.Gallery_imageid
  ]

}

resource "azurerm_virtual_machine_extension" "customscriptext" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}${count.index + 1}-avd_cse"
  virtual_machine_id = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.10"


  settings = <<SETTINGS
    {  

        "fileUris" : ["https://akterraformstorage.blob.core.windows.net/sessionhostconfig/sessionHostConfig.ps1?sp=****************************************-404934b17313&skt=2024-08-22T13:45:15Z&ske=2024-08-28T21:45:15Z&sks=b&skv=2022-11-02&spr=https&sv=2022-11-02&sr=b&sig=7KX5QbR%2BwsUSV9hhj%2BygqwyjRYe4EaiDaqOmCHd30E8%3D"]

    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
     {
         "storageAccountName": "akterraformstorage",
         "storageAccountKey": "************************************************************",
            "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -file sessionHostConfig.ps1"
     }
 PROTECTED_SETTINGS
 }

/* 
settings = <<-SETTINGS
  { 
    
    "script": "https://akterraformstorage.blob.core.windows.net/sessionhostconfig/sessionHostConfig.ps1?****************************************************ig=pQGlLe2oE3Q8znCbeg9zB9HK9j50yfmWyxELnCQaAG4%3D"
    "commandToExecute" : "powershell.exe -ExecutionPolicy Unrestricted -File sessionHostConfig.ps1"

}
SETTINGS 

}
 */
