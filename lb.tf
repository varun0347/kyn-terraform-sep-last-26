resource "azurerm_public_ip" "lb_publicip" {
  name = "${local.name_prefix}-${var.resource_group_name}-lb-publicip" #here i ll put each.key so that publicip will be create with unique name 
  #this vnet need location and resource group
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.project_tags
  
}

output "lb_publicip" {
  value = azurerm_public_ip.lb_publicip.ip_address
}

#create load balancer

resource "azurerm_lb" "web_lb" {
  name = "${local.name_prefix}-${var.resource_group_name}-lb" #here i ll put each.key so that publicip will be create with unique name 
  #this vnet need location and resource group
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_publicip.id
  }
}

#backendpool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name = "${local.name_prefix}-${var.resource_group_name}-lb-backendpool"
  loadbalancer_id = azurerm_lb.web_lb.id
}
#probes
#lb_rule
#backendpool association
#probes it is the health check
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name = "frontendprobe"
  protocol = "Tcp"
  port = 80 #currently it is checcking the http port
  #if you want to probe a path 
  //port = "http"
  //request_path =  /var/www/html/index.html 
  interval_in_seconds = 30 #evewry 30 second it is going to ping your application port or path 
  number_of_probes = 2 #if with in 1 min i dont get response it will stop sending the traffic to that particular instance
}
#lb_rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name = "lbrule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id = azurerm_lb_probe.lb_probe.id 
}
#backendpool association
resource "azurerm_network_interface_backend_address_pool_association" "nic_association" {
    for_each = var.instance
  network_interface_id = azurerm_network_interface.web_nic[each.key].id
  ip_configuration_name = azurerm_network_interface.web_nic[each.key].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
  
}