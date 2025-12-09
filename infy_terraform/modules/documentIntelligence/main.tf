resource "azurerm_cognitive_account" "preprod_document_intelligence" {
  name                = "${var.env}-document_intelligence_name"
  location            = var.location
  resource_group_name = var.rg_name

  kind     = var.kind     #"FormRecognizer"
  sku_name = var.sku_name #"S0"

  public_network_access_enabled = false
}


