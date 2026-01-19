locals {
  # Environment template - defines the structure and naming convention
  # Format: namespace[environment-name]
  environment_templates = {
    dev = {
      namespace   = "nonprod"
      suffix      = "-dev"
      description = "Development environment for ${var.product_name}"
    }
    test = {
      namespace   = "nonprod"
      suffix      = "-test"
      description = "Test/UAT environment for ${var.product_name}"
    }
    preprod = {
      namespace   = "preprod"
      suffix      = "-preprod"
      description = "Pre-production environment for ${var.product_name}"
    }
    prod = {
      namespace   = "prod"
      suffix      = "-prod"
      description = "Production environment for ${var.product_name}"
    }
    dr = {
      namespace   = "prod"
      suffix      = "-prod"
      description = "Disaster Recovery environment for ${var.product_name}"
    }
  }

  # Generate environment names dynamically
  # Example: product_name = "corporate"
  #   → corporate-dev
  #   → corporate-test
  #   → corporate-preprod
  #   → corporate-prod
  #   → corporate-DR
  environments = {
    for key, config in local.environment_templates :
    key => {
      name        = key == "dr" ? "${var.product_name}-DR" : "${var.product_name}${config.suffix}"
      namespace   = config.namespace
      suffix      = config.suffix
      description = config.description
    }
  }

  # Branch control rules based on environment type
  # These match your Azure DevOps branch structure from the screenshot
  branch_rules = {
    "-dev" = {
      allowed_branches = "refs/heads/main,refs/heads/staging,refs/heads/hotfix/*,refs/heads/release/*,refs/heads/feature/*,refs/heads/task/*"
      display_name     = "nonprod[dev] - Allow main, staging, hotfix, release, feature, and task branches"
    }
    "-test" = {
      allowed_branches = "refs/heads/main,refs/heads/hotfix/*,refs/heads/staging,refs/heads/release/*,refs/heads/feature/*"
      display_name     = "nonprod[test-uat] - Allow main, hotfix, staging, release, and feature branches"
    }
    "-preprod" = {
      allowed_branches = "refs/heads/main,refs/heads/staging,refs/heads/hotfix/*,refs/heads/release/*"
      display_name     = "preprod - Allow main, staging, hotfix, and release branches"
    }
    "-prod" = {
      allowed_branches = "refs/heads/main"
      display_name     = "prod - Allow only main branch"
    }
  }
}

################################################################################
# Data Sources
################################################################################

data "azuredevops_project" "project" {
  name = var.project_name
}

################################################################################
# Create Environments
################################################################################

resource "azuredevops_environment" "environments" {
  for_each = local.environments

  project_id  = data.azuredevops_project.project.id
  name        = each.value.name
  description = each.value.description
}

################################################################################
# Branch Controls
################################################################################

resource "azuredevops_check_branch_control" "branch_controls" {
  for_each = local.environments

  project_id           = data.azuredevops_project.project.id
  display_name         = local.branch_rules[each.value.suffix].display_name
  target_resource_id   = azuredevops_environment.environments[each.key].id
  target_resource_type = "environment"
  allowed_branches     = local.branch_rules[each.value.suffix].allowed_branches
}
