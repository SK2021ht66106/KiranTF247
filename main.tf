terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.53.0"
    }
  }
}

provider "azurerm" {

    features {}
  subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
  client_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
  client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
  tenant_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

resource "azurerm_resource_group" "main" {
  name     = "Terraformnew"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

}

resource "azurerm_subnet" "main" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}



module "DNSZone" {
  source                      = "./modules/DNS/DNSZone"
  resource_group_name         = azurerm_resource_group.main.name
  dns_zone_names              = ["saikiran.tech"]
  private_dns_zone_name       = "saikiran.local"
  private_dns_zone_vnet_links = [azurerm_virtual_network.main.id]
}


module "dns_records" {
  source = "./modules/DNS/DNSRecords"
  resource_group_name = azurerm_resource_group.main.name
  dns_zone_name = module.DNSZone.DNS_Zone_Name

  recordsets = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name    = ""
      type    = "MX"
      ttl     = 3600
      records = [
        "1,mail1",
        "5,mail2",
        "5,mail3",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 3600
      records = [
        "\"v=spf1 ip4:192.0.2.3 include -all\"",
      ]
    },
    {
      name    = "_sip._tcp"
      type    = "SRV"
      ttl     = 3600
      records = [
        "10,60,5060,sip1",
        "10,20,5060,sip2",
        "10,20,5060,sip3",
        "20,0,5060,sip4",
      ]
    },
  ]
}


module "traffic_manager" {
  source                 = "./modules/Trafficmanager"
  resource_group_name    = azurerm_resource_group.main.name
  profile_name           = "trafficmanager275"
  traffic_routing_method = "Weighted"
  max_return             = 3
  monitor_port           = 6379
  traffic_manager_endpoints = {
    user1_vmss_0 = {
      target_ip = "1.1.1.1"
      weight    = "100"
    },
    user1_vmss_1 = {
      target_ip = "2.2.2.2"
      weight    = "101"
    },
    user2_vmss_0 = {
      target_ip = "3.3.3.3"
      weight    = "102"
    },
  }
}


module "Appgateway"{
  source = "./modules/Appgateway"
  name                     = "simple2752"
  resource_group_name      = azurerm_resource_group.main.name
  resource_group_location  = azurerm_resource_group.main.location
  subnet_id                = azurerm_subnet.main.id
  allocation_method        = "Static"

  private_ip_address = "10.0.2.100"

  capacity = {
    min = 1
    max = 2
  }

  zones = ["1", "2", "3"]
}
