output "service_account_ids" {
  description = "IDs of created service accounts"
  value = {
    api_service = okta_user.api_service_account.id
    data_sync   = okta_user.data_sync_service_account.id
    monitoring  = okta_user.monitoring_service_account.id
  }
}

output "service_accounts_group_id" {
  description = "ID of the service accounts group"
  value       = okta_group.service_accounts.id
}
