resource "random_string" "random_key_gen" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# create appinsights
resource "azurerm_application_insights" "this" {
  name                = "appin-eus-${var.env}-${random_string.random_key_gen.result}"
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = var.application_type
}

# create app service plan
resource "azurerm_app_service_plan" "this" {
  name                = "appsp-eus-${var.env}-${random_string.random_key_gen.result}"
  resource_group_name = var.rg_name
  location            = var.location
  kind                = "FunctionApp"
  reserved = true # this has to be set to true for Linux. Not related to the Premium Plan
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# create a function app
resource "azurerm_function_app" "this" {
  name                       = "fnapp-eus-${var.env}-${random_string.random_key_gen.result}"
  resource_group_name        = var.rg_name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.this.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
  }
  os_type = "linux"
  site_config {
    linux_fx_version          = "node|14"
    use_32_bit_worker_process = false
  }
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  version                    = "~3"

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}