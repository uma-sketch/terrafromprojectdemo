resource "azurerm_network_interface" "this" {
  count               = var.vm_count
  name                = "${var.vm_name}-${count.index}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  count = var.vm_count

  network_interface_id    = azurerm_network_interface.this[count.index].id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = var.lb_backend_pool_id
}

resource "azurerm_windows_virtual_machine" "this" {
  count               = var.vm_count
  name                = "${var.vm_name}-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.this[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
