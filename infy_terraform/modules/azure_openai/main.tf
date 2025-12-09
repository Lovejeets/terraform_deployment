resource "azurerm_cognitive_account" "preprod" {
  name                = "${var.env}-OpenAI"
  location            = var.location
  resource_group_name = var.rg_name

  kind     = var.kind     #"AIServices"      # as per your input
  sku_name = var.sku_name #"S0"

  public_network_access_enabled = false
}
