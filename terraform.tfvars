################################################################################
# Terraform Variables Configuration
# Copy this file to terraform.tfvars and update with your values
################################################################################

# Required: Product name used to generate environment names
# Must contain only lowercase letters, numbers, and hyphens
# Examples: "corporate", "retail", "banking", "my-product"
product_name = "corporate"

# Optional: Azure DevOps project name
# Default: "DevOpsRepo"
# Uncomment and modify if your project name is different:
# project_name = "DevOpsRepo"
