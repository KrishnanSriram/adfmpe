resource "azurerm_resource_group" "this" {
  name = "rg-eus-${var.env}-${var.rg_name}"
  location = var.location
}