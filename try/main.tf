#module "cognito_user_pool" {
#  source  = "mineiros-io/cognito-user-pool/aws"
#  version = "~> 0.9.0"
#
#  name = "complete-example-userpool"
#
#  # We allow the public to create user profiles
#  allow_admin_create_user_only = false
#
#  enable_username_case_sensitivity = false
#  advanced_security_mode           = "ENFORCED"
#
#  alias_attributes = [
#    "email"
#  ]
#
#  auto_verified_attributes = [
#    "email"
#  ]
#
#  account_recovery_mechanisms = [
#    {
#      name     = "verified_email"
#      priority = 1
#    }
#  ]
#
#  # If invited by an admin
#  invite_email_subject = "You've been invited to rimpa"
#  invite_email_message = "Hi {username}, your temporary password is '{####}'."
#
#
#  domain                = "rimpa-dev"
#  default_email_option  = "CONFIRM_WITH_LINK"
#  email_subject_by_link = "Your Verification Link"
#  email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}."
#
#
#  challenge_required_on_new_device = true
#  user_device_tracking             = "USER_OPT_IN"
#
#  # These paramters can be used to configure SES for emails
#  # email_sending_account  = "DEVELOPER"
#  # email_reply_to_address = "support@mineiros.io"
#  # email_from_address     = "noreply@mineiros.io"
#  # email_source_arn       = "arn:aws:ses:us-east-1:999999999999:identity"
#
#
#  password_minimum_length    = 40
#  password_require_lowercase = true
#  password_require_numbers   = true
#  password_require_uppercase = true
#  password_require_symbols   = true
#
#  temporary_password_validity_days = 3
#
#  schema_attributes = [
#    {
#      name       = "gender", # overwrites the default attribute 'gender'
#      type       = "String"
#      required   = true
#      min_length = 1
#      max_length = 2048
#    },
#    {
#      name                     = "alternative_name"
#      type                     = "String"
#      developer_only_attribute = false,
#      mutable                  = true,
#      required                 = false,
#      min_length               = 0,
#      max_length               = 2048
#    },
#    {
#      name      = "friends_count"
#      type      = "Number"
#      min_value = 0,
#      max_value = 100
#    },
#    {
#      name = "is_active"
#      type = "Boolean"
#
#    },
#    {
#      name = "last_seen"
#      type = "DateTime"
#    }
#  ]
#
#  clients = [
#    {
#      name                 = "android-mobile-client"
#      read_attributes      = ["email", "email_verified", "preferred_username"]
#      allowed_oauth_scopes = ["email", "openid"]
#      allowed_oauth_flows  = ["implicit"]
#      callback_urls        = ["https://rimpa.io/callback", "https://rimpa.io/anothercallback"]
#      default_redirect_uri = "https://rimpa.io/callback"
#      generate_secret      = true
#    }
#  ]
#
#  tags = {
#    environment = "Dev"
#  }
#}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name = "${var.user_pool_name}"
  Rimpa_app = "${var.Rimpa_app}"
  Rimpa_app_env = "${var.Rimpa_app_env}"
  Name = "${var.Name}"
  user_pool_domain = "${var.user_pool_domain}"
  user_pool_client = "${var.user_pool_client}"
  scope_name = "${var.scope_name}"
#  ui_custom = "${var.ui_custom}"

}