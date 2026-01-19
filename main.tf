################################################################################
# Azure DevOps Dynamic Environment & Branch Control Module
################################################################################

module "branch_control" {
  source = "./modules/branch_control"

  product_name = var.product_name
  project_name = var.project_name
}
