output "assigned_roles_azapi" {
  description = "Canonical map of permanent role assignments ready for azapi_resource consumption (name + body + scope derived)."
  value       = local.assigned_roles_azapi
}

output "eligible_assigned_roles_azapi" {
  description = "Canonical map of eligible role assignments ready for azapi_resource consumption."
  value       = local.eligible_assigned_roles_azapi
}

output "group_id" {
  description = "The ID of the created Entra ID group (Microsoft Graph group id)."
  value       = azuread_group.this.object_id
}

output "group_object_id" {
  description = "The Object ID of the created Entra ID group (same as group_id)."
  value       = azuread_group.this.object_id
}

output "resource_id" {
  description = "The Azure resource ID of the Entra ID group. This output is required by Azure Verified Modules specification RMFR7."
  value       = azuread_group.this.object_id
}
