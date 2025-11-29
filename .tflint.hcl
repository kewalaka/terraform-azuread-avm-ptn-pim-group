config {
  format = "compact"
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "azurerm" {
  enabled = true
}

# Disable check for terraform_module_version on role_definitions module
# This utility module uses a version constraint to allow compatible updates
rule "terraform_module_version" {
  enabled = false
}
