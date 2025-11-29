# Group and role assignment resources

# Role definition name-to-ID lookup using AVM utility module
# Uses pessimistic version constraint (~>) to allow compatible minor/patch updates
# while maintaining API compatibility per semantic versioning
module "role_definitions" {
  source  = "Azure/avm-utl-roledefinitions/azure"
  version = "0.1.0"
  count   = var.role_definition_lookup_scope == null ? 0 : 1

  enable_telemetry      = var.enable_telemetry
  role_definition_scope = var.role_definition_lookup_scope
  use_cached_data       = !var.assigned_role_definition_lookup_use_live_data
}

resource "azuread_group" "this" {
  display_name       = var.name
  assignable_to_role = coalesce(var.group_settings.assignable_to_role, true)
  description = (
    var.group_settings.description != null ? var.group_settings.description :
    (trimspace(var.group_description) != "" ? var.group_description : null)
  )
  mail_enabled = coalesce(var.group_settings.mail_enabled, false)
  mail_nickname = coalesce(
    try(var.group_settings.mail_nickname, null),
    lower(substr(join("", regexall("[A-Za-z0-9]", var.name)), 0, 64))
  )
  owners           = local.group_owners
  security_enabled = coalesce(var.group_settings.security_enabled, true)
  types            = coalesce(try(var.group_settings.types, null), [])
  visibility       = coalesce(var.group_settings.visibility, "Private")

  dynamic "dynamic_membership" {
    for_each = var.group_settings.dynamic_membership != null ? [var.group_settings.dynamic_membership] : []

    content {
      enabled = dynamic_membership.value.processing_state == "On"
      rule    = dynamic_membership.value.rule
    }
  }

  lifecycle {
    precondition {
      condition = (
        !(coalesce(var.group_settings.assignable_to_role, true)) ||
        length(local.group_owners) > 0 ||
        var.allow_role_assignable_group_without_owner
      )
      error_message = "Role-assignable groups should have at least one owner (delegation and recovery best practice). See: Graph isAssignableToRole (https://learn.microsoft.com/graph/api/resources/group?view=graph-rest-1.0) and Assign roles using groups (https://learn.microsoft.com/azure/role-based-access-control/role-assignments-group). To bypass (not recommended), set allow_role_assignable_group_without_owner = true."
    }
  }
}

resource "random_uuid" "assigned_role_name" {
  for_each = var.assigned_roles
}

resource "azapi_resource" "assigned_roles" {
  for_each = local.assigned_roles_azapi

  name                 = each.value.name
  parent_id            = var.assigned_roles[each.key].scope
  type                 = local.assigned_roles_type
  body                 = each.value.body
  create_headers       = var.enable_telemetry ? { "User-Agent" = local.avm_azapi_header } : null
  delete_headers       = var.enable_telemetry ? { "User-Agent" = local.avm_azapi_header } : null
  ignore_null_property = true
  read_headers         = var.enable_telemetry ? { "User-Agent" = local.avm_azapi_header } : null
  replace_triggers_refs = var.assigned_role_replace_on_immutable_value_changes ? [
    "properties.principalId",
    "properties.roleDefinitionId",
    "properties.scheduleInfo",
  ] : null
  # Retry logic to handle Azure AD replication delays
  retry = {
    error_message_regex = [
      "PrincipalNotFound",
      "does not exist in the directory"
    ]
    interval_seconds     = 10
    max_interval_seconds = 60
  }
  update_headers = var.enable_telemetry ? { "User-Agent" = local.avm_azapi_header } : null
}



