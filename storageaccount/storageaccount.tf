resource "random_string" "random_key_gen" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource azurerm_storage_account "this" {
  name                     = "saeus${var.env}${var.sa_name}${random_string.random_key_gen.result}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# crearte BLOB container
resource azurerm_storage_container "script_container" {
  name                  = "shirscripts"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.this ]
}