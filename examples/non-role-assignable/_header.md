# Non-Role-Assignable Group Example with Nested Eligibility

This example demonstrates creating a standard Entra ID security group (not role-assignable) with PIM (Privileged Identity Management) enabled, using a nested group for eligibility management.

## Why use this pattern?

- **Avoid Limits**: Entra ID has a hard limit of 500 role-assignable groups per tenant. Standard groups do not have this limit.
- **Resource Access**: These groups work perfectly for Azure Resource RBAC (e.g., Contributor on a Subscription).
- **Limitations**: These groups **cannot** be assigned Entra ID roles (e.g., Global Administrator, User Administrator).
- **Scalability**: By making a standard "Operations Team" group eligible, you can manage PIM eligibility simply by adding or removing users from that group.

## What the example builds

- A standard security group (`assignable_to_role = false`) as the PIM-enabled group.
- An "Operations Team" group that is assigned as an eligible member.
- An operator user who is a member of the Operations Team.
- PIM onboarding is triggered automatically by the eligible member assignment.
