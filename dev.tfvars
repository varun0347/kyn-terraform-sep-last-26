project_name = "kyn-project"
environment = "dev"
resource_group_name = "varun-rg"
resource_group_location = "eastus"
vnet_address_space = ["172.31.0.0/16"]
web_subnet_address = ["172.31.1.0/24"]
instance = {
    web1 = {
    vm_size = "Standard_F2as_v7"
    availability_zone = "1" #each.value.availability_zone 1
    subnet_id = "web"
  }
}