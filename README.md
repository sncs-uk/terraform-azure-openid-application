# Azure AD OpenID Terraform module

Terraform module which creates an AzureAD OpenID application.


## Usage
```hcl
module "application" {
  source                        = "github.com/sncs-uk/terraform-azure-openid-application"

  application_name              = "my-test-application"
  application_description       = "A test application"
  application_sign_in_audience  = "AzureADMyOrg"
  redirect_uris                 = ["https://application.example.com/callback"]
  grant_admin_consent           = true
  create_enterprise_application = true
}
```

## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.39 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.39 |
