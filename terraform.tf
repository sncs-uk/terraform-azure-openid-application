terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.39"
    }
  }
}

resource "random_uuid" "openid_uuids" {
  count = 3
}

data "azuread_service_principal" "ms_graph" {
  display_name = "Microsoft Graph"
}

resource "azuread_application" "application" {
  display_name                    = var.application_name
  description                     = var.application_description
  owners                          = []
  sign_in_audience                = var.application_sign_in_audience
  device_only_auth_enabled        = false
  fallback_public_client_enabled  = false

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 1

    oauth2_permission_scope {
      admin_consent_description   = "Allow the application to access ${var.application_name} on behalf of the signed-in user."
      admin_consent_display_name  = "Access ${var.application_name}"
      enabled                     = true
      id                          = element(random_uuid.openid_uuids, 0).result
      type                        = "User"
      user_consent_description    = "Allow the application to access ${var.application_name} on your behalf."
      user_consent_display_name   = "Access ${var.application_name}"
      value                       = "user_impersonation"
    }

  }

  app_role {
    allowed_member_types = ["User"]
    description          = "User"
    display_name         = "User"
    enabled              = true
    id                   = element(random_uuid.openid_uuids, 1).result
    value                = "User"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "msiam_access"
    display_name         = "msiam_access"
    enabled              = true
    id                   = element(random_uuid.openid_uuids, 2).result
    value                = ""
  }

  feature_tags {
    custom_single_sign_on = false
    enterprise            = false
    gallery               = false
    hide                  = false
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }


  group_membership_claims = ["All"]

  web {
    redirect_uris = var.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
}

resource "azuread_service_principal" "enterprise_application" {
  application_id                = azuread_application.application.application_id
  app_role_assignment_required = true
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.application.object_id
}

resource "null_resource" "grant_admin_consent" {
  count = var.grant_admin_consent ? 1 : 0
  triggers = {
    resourceId = data.azuread_service_principal.ms_graph.object_id
    clientId   = azuread_service_principal.enterprise_application.object_id
    scope      = "User.Read"
  }

  provisioner "local-exec" {
    command = <<-GRANTCONSENTCMD
      az rest --method POST \
        --uri 'https://graph.microsoft.com/v1.0/oauth2PermissionGrants' \
        --headers 'Content-Type=application/json' \
        --body '{
          "clientId": "${self.triggers.clientId}",
          "consentType": "AllPrincipals",
          "principalId": null,
          "resourceId": "${self.triggers.resourceId}",
          "scope": "${self.triggers.scope}"
        }'
      GRANTCONSENTCMD
  }
}
