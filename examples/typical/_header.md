# Typical Example: PIM for Groups with Direct User Eligibility

This scenario demonstrates the standard "PIM for Groups" pattern where users are directly assigned eligibility to the PIM-enabled group.

In this configuration, users are made eligible for the PIM-enabled group directly. When they need elevated permissions, they activate their membership in the PIM-enabled group. This approach aligns with the Microsoft recommendation to ["Ensure that role-assignable groups don't have non-role assignable groups as members"](https://learn.microsoft.com/en-us/entra/id-governance/best-practices-secure-id-governance#preventing-lateral-movement), preventing potential lateral movement paths.

This example also illustrates how to configure common PIM policy settings, such as requiring **ticket information** and **approval** from a designated approver during activation.

## What the example builds

- **PIM-Enabled Group**: A role-assignable security group that holds a permanent `Contributor` role assignment on the subscription.
- **Direct Eligibility**: A user is assigned as an *eligible member* of the PIM-Enabled Group.
- **Demo Identities**: Creates a PIM approver and an operator user.
- **PIM Policy**: Configured to require MFA, **ticket information**, **approval**, and a 4-hour activation window.

## Permissions required

Run this example with the same app registration or credentials you use for the full demo. The identity must have:

- Azure RBAC: `User Access Administrator` (or `Owner`) for the subscription.
- Microsoft Graph application permissions:
  - `Domain.Read.All`
  - `User.Read.All`
  - `User.ReadWrite.All`
  - `Group.Read.All`
  - `Group.ReadWrite.All`
  - `PrivilegedAccess.ReadWrite.AzureADGroup`
  - `PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup`
  - `PrivilegedEligibilitySchedule.Remove.AzureADGroup`
  - `RoleManagementPolicy.ReadWrite.AzureADGroup`
  - `RoleManagement.ReadWrite.Directory`
  - `Directory.ReadWrite.All`

Grant and admin-consent these scopes on the service principal, then run `terraform init`, `terraform plan`, and `terraform apply` inside this folder.

## References

- [Privileged Identity Management (PIM) for Groups – Making group of users eligible for Microsoft Entra role](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/concept-pim-for-groups#making-group-of-users-eligible-for-microsoft-entra-role)
