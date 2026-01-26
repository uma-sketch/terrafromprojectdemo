resource "azurerm_resource_group" "rg" {
  name     = "rg-lb-windows"
  location = "CentralIndia"
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-main"
  subnet_name         = "subnet-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "windows_vm" {
  source              = "./modules/windows-vm"
  vm_name             = "app-vm"
  vm_count            = 1
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  lb_backend_pool_id  = module.loadbalancer.backend_pool_id
  admin_username      = "azureadmin"
  admin_password      = var.admin_password
}

