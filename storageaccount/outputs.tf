output "sa_name" {
  value = azurerm_storage_account.this.name
}

output "sa_script_container" {
  value = azurerm_storage_container.script_container.name
}

output "sa_id" {
  value = azurerm_storage_account.this.id
}