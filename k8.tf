#terraformconfig_Sec_Auto_lab
provider "azurerm" {
  features {}
  }

data "azurerm_subscription" "primary" {
}


resource "azurerm_resource_group" "Mentee-Sergey_Zelentsov" {
  name     = "Mentee-Sergey_Zelentsov"
  location = "eastus" #eastus #eastasia
  tags     = {
    author = "Sergei_Zelentsov@epam.com"
    usage  = "Edu"
  }
}

resource "azurerm_public_ip" "workernode_public_ip" {
  name                = "workernode_public_ip"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  allocation_method   = "Dynamic"
  tags = {
      usage  = "Edu"
      author = "Sergei_Zelentsov@epam.com"
    }
}

resource "azurerm_subnet_network_security_group_association" "subnet_NSG_association" {
  subnet_id           = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface" "NIC2" {
  name                = "NIC2"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
      author = "Sergei_Zelentsov@epam.com"
      usage  = "Edu"
    }
}
resource "azurerm_network_interface" "NIC3" {
  name                = "NIC3"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.workernode_public_ip.id
  }
  tags = {
      author = "Sergei_Zelentsov@epam.com"
      usage  = "Edu"
    }
}

# Create SSH key
resource "tls_private_key" "access_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#MasterVM

resource "azurerm_linux_virtual_machine" "MasterNode" {
  name                = "Masternode"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  network_interface_ids = [azurerm_network_interface.NIC2.id]
  admin_username      = "azureuser"
  disable_password_authentication = true
  size             = "Standard_B2s"
    os_disk {
    name              = "MasterNode_osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

connection {
  type = "ssh"
  host = azurerm_linux_virtual_machine.MasterNode.private_ip_address
  port = 22
  user = azurerm_linux_virtual_machine.MasterNode.admin_username
  private_key = file("~/.ssh/id_rsa")
}

provisioner "file" {
  source = "install_master.sh"
  destination = "/tmp/install_master.sh"
}
provisioner "file" {
  source = "~/.ssh/id_rsa"
  destination = "/tmp/id_rsa"
}


provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/install_master.sh",
    "chmod 400 /tmp/id_rsa",
    "echo $(azurerm_linux_virtual_machine.MasterNode.admin_password) | sudo -S /tmp/install_master.sh",
    "rm /tmp/install_master.sh",
  ]
}

}     


#WorkerVM

resource "azurerm_linux_virtual_machine" "Workernode" {
  name                = "Workernode"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  network_interface_ids = [azurerm_network_interface.NIC3.id]
  admin_username      = "azureuser"
  disable_password_authentication = true
  size             = "Standard_B2s"
    os_disk {
    name              = "Workernode_osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

connection {
  type = "ssh"
  host = azurerm_linux_virtual_machine.Workernode.private_ip_address
  port = 22
  user = azurerm_linux_virtual_machine.Workernode.admin_username
  private_key = file("~/.ssh/id_rsa")
}

provisioner "file" {
  source = "install_worker.sh"
  destination = "/home/azureuser/install_worker.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /home/azureuser/install_worker.sh",
  ]
}
}     



output "Go_SSH_MasterNode" {
  value = "ssh azureuser@${azurerm_linux_virtual_machine.MasterNode.private_ip_address} -o StrictHostKeyChecking=no"
}
output "Go_SSH_Workernode" {
  value = "ssh azureuser@${azurerm_linux_virtual_machine.Workernode.public_ip_address} -o StrictHostKeyChecking=no"
}
output "your_app_is_gonna_be_available_on" {
  value = "${azurerm_linux_virtual_machine.Workernode.public_ip_address}:30000"
}

