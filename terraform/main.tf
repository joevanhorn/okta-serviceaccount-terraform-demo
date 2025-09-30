# terraform/main.tf
# Terraform configuration for deploying service accounts to Okta

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Configure the Okta Provider
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Create a group for service accounts
resource "okta_group" "service_accounts" {
  name        = "Service Accounts"
  description = "Group for all service accounts"
}

# Example Service Account 1: API Integration
resource "okta_user" "api_service_account" {
  first_name = "API"
  last_name  = "Service Account"
  login      = "api-service@${var.okta_org_name}.com"
  email      = "api-service@${var.okta_org_name}.com"
  
  status = "ACTIVE"
}

resource "okta_group_memberships" "api_service_membership" {
  group_id = okta_group.service_accounts.id
  users = [
    okta_user.api_service_account.id,
  ]
}

# Example Service Account 2: Data Sync
resource "okta_user" "data_sync_service_account" {
  first_name = "DataSync"
  last_name  = "Service Account"
  login      = "data-sync-service@${var.okta_org_name}.com"
  email      = "data-sync-service@${var.okta_org_name}.com"
  
  status = "ACTIVE"
}

resource "okta_group_memberships" "data_sync_service_membership" {
  group_id = okta_group.service_accounts.id
  users = [
    okta_user.data_sync_service_account.id,
  ]
}

# Example Service Account 3: Monitoring
resource "okta_user" "monitoring_service_account" {
  first_name = "Monitoring"
  last_name  = "Service Account"
  login      = "monitoring-service@${var.okta_org_name}.com"
  email      = "monitoring-service@${var.okta_org_name}.com"
  
  status = "ACTIVE"
}

# Example Service Account 4: nhi-demo
resource "okta_user" "nhi-demo" {
  first_name = "NHI Demo"
  last_name  = "Service Account"
  login      = "nhi-demo@${var.okta_org_name}.com"
  email      = "nhi-demo@${var.okta_org_name}.com"
  
  status = "ACTIVE"
}

resource "okta_group_memberships" "monitoring_service_membership" {
  group_id = okta_group.service_accounts.id
  users = [
    okta_user.monitoring_service_account.id,
  ]
}

# testing github actions workflow
