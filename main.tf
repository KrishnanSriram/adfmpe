module "rg" {
  source = "./resourcegroup"
  rg_name = var.rg_name
  location = var.location
  env = var.env
}

module "storageaccount" {
  source = "./storageaccount"
  sa_name = var.sa_name
  rg_name = module.rg.rg_name
  location = module.rg.location
  env = var.env
  depends_on = [ module.rg ]
}

module "adf" {
  source = "./adf"
  location = module.rg.location
  adf_name = var.adf_name
  rg_name = module.rg.rg_name
  sa_id = module.storageaccount.sa_id
  env = var.env
  depends_on = [ module.rg ]
}