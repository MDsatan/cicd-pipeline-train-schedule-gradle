#terraformconfig_Sec_Auto_lab
provider "azurerm" {
  features {}
  }

resource "azurerm_resource_group" "Mentee-Sergey_Zelentsov" {
  name     = "Mentee-Sergey_Zelentsov"
  location = "eastus" #eastus #eastasia
  tags     = {
    author = "Sergei_Zelentsov@epam.com"
    usage  = "Edu"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VNET"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  tags = {
      usage  = "Edu"
      author = "Sergei_Zelentsov@epam.com"
    }
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
    resource_group_name  = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip1" {
  name                = "public_ip1"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  allocation_method   = "Dynamic"
  tags = {
      usage  = "Edu"
      author = "Sergei_Zelentsov@epam.com"
    }
}
resource "azurerm_public_ip" "masternode_public_ip" {
  name                = "masternode_public_ip"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  allocation_method   = "Dynamic"
  tags = {
      usage  = "Edu"
      author = "Sergei_Zelentsov@epam.com"
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
resource "azurerm_network_security_group" "NSG" {
  name                = "NSG"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  tags                = {
    author = "Sergei_Zelentsov@epam.com"
    usage  = "Edu"
    }
  security_rule {
    name                 = "Allow_SSH"
    priority              = 100
    access                = "Allow"
    direction             = "Inbound"
    protocol              = "Tcp"
    source_port_range    = "*"
    destination_port_ranges = ["22"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                 = "Allow_HTTP"
    priority              = 101
    access                = "Allow"
    direction             = "Inbound"
    protocol              = "Tcp"
    source_port_range    = "*"
    destination_port_ranges = ["8080"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }



}
resource "azurerm_subnet_network_security_group_association" "subnet_NSG_association" {
  subnet_id           = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface" "NIC" {
  name                = "NIC"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip1.id
  }
  tags = {
      author = "Sergei_Zelentsov@epam.com"
      usage  = "Edu"
    }
}
resource "azurerm_network_interface" "NIC2" {
  name                = "NIC2"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.masternode_public_ip.id
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

#BuildVM

resource "azurerm_linux_virtual_machine" "BuildNode" {
  name                = "BuildNode"
  location            = azurerm_resource_group.Mentee-Sergey_Zelentsov.location
  resource_group_name = azurerm_resource_group.Mentee-Sergey_Zelentsov.name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  admin_username      = "azureuser"
  disable_password_authentication = true
  size             = "Standard_B2s"
    os_disk {
    name              = "BuildNode_osdisk"
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
  host = azurerm_linux_virtual_machine.BuildNode.public_ip_address
  port = 22
  user = azurerm_linux_virtual_machine.BuildNode.admin_username
  private_key = file("~/.ssh/id_rsa")
}

provisioner "file" {
  source = "buildnode.sh"
  destination = "/tmp/buildnode.sh"
}
provisioner "file" {
  source = "~/.ssh/id_rsa"
  destination = "/tmp/id_rsa"
}


provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/buildnode.sh",
    "echo $(azurerm_linux_virtual_machine.BuildNode.admin_password) | sudo -S /tmp/buildnode.sh",
    "rm /tmp/buildnode.sh",
    "sudo snap install terraform --classic",
    "sudo mv /tmp/id_rsa /var/lib/jenkins/id_rsa"
  ]
}

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
  host = azurerm_linux_virtual_machine.MasterNode.public_ip_address
  port = 22
  user = azurerm_linux_virtual_machine.MasterNode.admin_username
  private_key = file("~/.ssh/id_rsa")
}

provisioner "file" {
  source = "install_worker.sh"
  destination = "/tmp/install_worker.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/install_worker.sh",
    "echo $(azurerm_linux_virtual_machine.MasterNode.admin_password) | sudo -S /tmp/install_worker.sh",
    "rm /tmp/install_worker.sh",
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
  host = azurerm_linux_virtual_machine.Workernode.public_ip_address
  port = 22
  user = azurerm_linux_virtual_machine.Workernode.admin_username
  private_key = file("~/.ssh/id_rsa")
}

provisioner "file" {
  source = "install_worker.sh"
  destination = "/tmp/install_worker.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/install_worker.sh",
    "echo $(azurerm_linux_virtual_machine.Workernode.admin_password) | sudo -S /tmp/install_worker.sh",
    "rm /tmp/install_worker.sh",
  ]
}
}     




output "Go_SSH_BuildNode" {
  value = "ssh azureuser@${azurerm_linux_virtual_machine.BuildNode.public_ip_address}"
}
output "Go_SSH_MasterNode" {
  value = "ssh azureuser@${azurerm_linux_virtual_machine.MasterNode.public_ip_address}"
}
output "Go_SSH_Workernode" {
  value = "ssh azureuser@${azurerm_linux_virtual_machine.Workernode.public_ip_address}"
}

output "Go_Jenkins" {
  value = "http://${azurerm_linux_virtual_machine.BuildNode.public_ip_address}:8080"
}


