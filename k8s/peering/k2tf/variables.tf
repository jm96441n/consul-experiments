variable "name" {
  description = "Tutorial name"
  type        = string
  default     = "cluster-2"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name = "${var.name}-${random_string.suffix.result}"
}
