output "product_name" {
  description = "The product name used for environment generation"
  value       = var.product_name
}

output "environment_names" {
  description = "Generated environment names"
  value = {
    for k, v in local.environments : k => v.name
  }
}

output "environment_ids" {
  description = "Map of environment keys to their IDs"
  value = {
    for k, v in local.environments : k => azuredevops_environment.environments[k].id
  }
}

output "branch_control_summary" {
  description = "Summary of branch controls applied to each environment"
  value = {
    for k, v in local.environments : v.name => {
      environment_id   = azuredevops_environment.environments[k].id
      allowed_branches = local.branch_rules[v.suffix].allowed_branches
      display_name     = local.branch_rules[v.suffix].display_name
    }
  }
}

output "deployment_hierarchy" {
  description = "Visual representation of the deployment pipeline"
  value       = <<-EOT
  
  Deployment Pipeline for: ${var.product_name}
  ═════════════════════════════════════════════════════════════
  
  🚀 DEVELOPMENT
     Environment: ${local.environments["dev"].name}
     Branches:    main, staging, hotfix/*, release/*, feature/*, task/*
     
  ⬇️
  
  🧪 TEST/UAT
     Environment: ${local.environments["test"].name}
     Branches:    main, staging, hotfix/*, release/*, feature/*
     
  ⬇️
  
  🔍 PRE-PRODUCTION
     Environment: ${local.environments["preprod"].name}
     Branches:    main, staging, hotfix/*, release/*
     
  ⬇️
  
  🏭 PRODUCTION
     Environment: ${local.environments["prod"].name}
     Branches:    main only
     
  🔄 DISASTER RECOVERY
     Environment: ${local.environments["dr"].name}
     Branches:    main only
  
  ═════════════════════════════════════════════════════════════
  EOT
}
