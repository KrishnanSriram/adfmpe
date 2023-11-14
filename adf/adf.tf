resource "random_string" "random_key_gen" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_data_factory" "this" {
  name = "adf-eus-${var.env}-${var.adf_name}-${random_string.random_key_gen.result}"
  location = var.location
  resource_group_name = var.rg_name
  managed_virtual_network_enabled = true
}

resource "azurerm_data_factory_managed_private_endpoint" "example" {
  name               = "mpe-sa-${var.env}-${random_string.random_key_gen.result}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.sa_id
  subresource_name   = "blob"
}