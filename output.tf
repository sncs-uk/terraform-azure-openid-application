output "application_id" {
  value     = azuread_application.application.application_id
}
output "object_id" {
  value     = azuread_application.application.object_id
}
output "client_secret" {
  value     = azuread_application_password.client_secret.value
  sensitive = true
}
output "enterprise_application" {
  value     = azuread_service_principal.enterprise_application
}
