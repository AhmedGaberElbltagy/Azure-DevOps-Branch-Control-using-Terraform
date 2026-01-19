################################################################################
# Outputs (Root Module)
################################################################################

output "product_name" {
  description = "The product name used for environment generation"
  value       = module.branch_control.product_name
}

output "environment_names" {
  description = "Generated environment names"
  value       = module.branch_control.environment_names
}

output "environment_ids" {
  description = "Map of environment keys to their IDs"
  value       = module.branch_control.environment_ids
}

output "branch_control_summary" {
  description = "Summary of branch controls applied to each environment"
  value       = module.branch_control.branch_control_summary
}

output "deployment_hierarchy" {
  description = "Visual representation of the deployment pipeline"
  value       = module.branch_control.deployment_hierarchy
}

