terraform {
  backend "azurerm" {
    resource_group_name = "varun-terraform"
    storage_account_name = "terraformstoragevarun"
    container_name = "tfstate"
    key = "kyn-project-dev.tfstate"
  }
}