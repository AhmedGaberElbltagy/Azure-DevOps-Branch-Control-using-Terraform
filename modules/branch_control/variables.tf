variable "product_name" {
  description = "Product name used to generate environment names (e.g., 'corporate', 'retail', 'banking')"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.product_name))
    error_message = "Product name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_name" {
  description = "Azure DevOps project name"
  type        = string
  default     = "DevOpsRepo"
}
