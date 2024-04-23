variable "application_name" {
  type        = string
  description = "The display name for the application."
}
variable "application_description" {
  type        = string
  description = "A description of the application, as shown to end users."
  default     = ""
}
variable "application_sign_in_audience" {
  type        = string
  description = "Application sign-in audience. Must be one of `AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount` or `PersonalMicrosoftAccount`. Defaults to `AzureADMyOrg`"
  default     = "AzureADMyOrg"
}
variable "redirect_uris" {
  type        = list(string)
  description = "A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent. Must be a valid `http` URL or a URN."
}
variable "grant_admin_consent" {
  type        = bool
  description = "Whether to grant admin consent for the entire organisation."
  default     = false
}
