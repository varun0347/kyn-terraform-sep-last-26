project_name = "kyn-project"
environment = "test"
resource_group_name = "varun-rg"
resource_group_location = "eastus"
vnet_address_space = ["10.0.0.0/16"]
web_subnet_address = ["10.0.1.0/24"]
instance = {
    web1 = {
    vm_size = "Standard_F2as_v7"
    availability_zone = "1" #each.value.availability_zone 1
    subnet_id = "web"
  }
  web2 = {
    vm_size = "Standard_F2as_v7"
    availability_zone = "2" #each.value.availability_zone 1
    subnet_id = "web"
  }
}