resource "aws_cognito_user_pool" "test_pool" {
  name = "${var.user_pool_name}"
  auto_verified_attributes = ["email"]
  alias_attributes = ["email"]
#  username_attributes = ["email"]
#  username_configuration {
#    case_sensitive = false
#  }

  password_policy {
    minimum_length    = 8
    require_numbers   = true
    require_symbols   = false
    require_lowercase = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }


  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  mfa_configuration = "OFF"
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  schema {
    name = "email"
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    required = true

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }


  tags = {
    rimpa_app_env = "${var.Rimpa_app_env}",
    rimpa_app     = "${var.Rimpa_app}",
    Name          = "${var.Name}"
  }
#  domain = ""
#  user_pool_id = ""
}
resource "aws_cognito_user_pool_client" "test_client" {
  name         = "${var.user_pool_client}"
  user_pool_id = "${aws_cognito_user_pool.test_pool.id}"
  token_validity_units {
    refresh_token = "days"
    access_token = "minutes"
    id_token = "hours"
  }
  refresh_token_validity = 30
  access_token_validity = 60
  id_token_validity = 1
  generate_secret = true
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH","ALLOW_USER_SRP_AUTH","ALLOW_REFRESH_TOKEN_AUTH"]
  enable_token_revocation = true
#  ---- To use without client credentials ----
#  allowed_oauth_scopes = ["email", "phone", "openid", "profile", "aws.cognito.signin.user.admin"]

  read_attributes      = ["address", "birthdate", "email", "email_verified",
    "family_name", "gender", "given_name", "locale", "middle_name", "name",
    "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username",
    "profile", "updated_at", "website", "zoneinfo"]
  write_attributes     = ["address", "birthdate", "email", "family_name", "gender", "given_name",
    "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username",
    "profile", "updated_at", "website", "zoneinfo"]
  #  ---- To use without client credentials ----
#  supported_identity_providers = ["COGNITO"]
  callback_urls = ["https://rimpa77.com/"]
  default_redirect_uri = "https://rimpa77.com/"
  logout_urls   = ["https://rimpa77.com/logout"]
  allowed_oauth_flows_user_pool_client = true
  #  ---- To use without client credentials ----
  #  allowed_oauth_flows = ["code", "implicit"]

  #  ---- To use with client credentials ----
  allowed_oauth_flows = ["client_credentials"]
  depends_on = [
  "aws_cognito_resource_server.test_server",
    "aws_cognito_user_pool.test_pool"
  ]

  allowed_oauth_scopes = ["${aws_cognito_resource_server.test_server.identifier}/${var.scope_name}"]
#  allowed_oauth_scopes = ["email","profile"]   contradicts with oauth flows
}
resource "aws_cognito_user_pool_domain" "domain_name" {
  domain = "${var.user_pool_domain}"
  user_pool_id = "${aws_cognito_user_pool.test_pool.id}"
  depends_on = ["aws_cognito_resource_server.test_server",
  "aws_cognito_user_pool.test_pool"]
}
resource "aws_cognito_resource_server" "test_server" {
  identifier   = "https://autho.123"
  name         = "author"
  user_pool_id = "${aws_cognito_user_pool.test_pool.id}"
  scope {
    scope_description = "read"
    scope_name        = "${var.scope_name}"
  }
}
#resource "aws_cognito_user_pool_domain" "main" {
#  domain          = "<example-domain.example.com>"
#  certificate_arn = aws_acm_certificate.cert.arn
#  user_pool_id    = aws_cognito_user_pool.pool.id
#}
#
#resource "aws_cognito_user_pool" "pool" {
#  name = "<example-pool>"
#}
#
#data "aws_route53_zone" "example" {
#  name = "<example.com>"
#}
#
#resource "aws_route53_record" "auth-cognito-A" {
#  name    = aws_cognito_user_pool_domain.main.domain
#  type    = "A"
#  zone_id = data.aws_route53_zone.example.zone_id
#  alias {
#    evaluate_target_health = false
#    name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
#    # This zone_id is fixed
#    zone_id = "Z2FDTNDATAQYW2"
#  }
##}
#resource "aws_cognito_user_pool_ui_customization" "ui_custom" {
##  name = "${var.ui_custom}"
#  user_pool_id = aws_cognito_user_pool.test_pool.id
#  css        = ".label-customizable {font-weight: 400;}"
#  image_file = filebase64("logo.png")
#}

#resource "aws_cognito_identity_provider" "example_provider" {
#  user_pool_id  = "${aws_cognito_user_pool.test_pool.id}"
#  provider_name = "GOOGLE"
#  provider_type = "GOOGLE"
#
#  provider_details = {
##    client_id        = "your client_id"
##    client_secret    = "your client_secret"
#    authorize_scopes = ["email"]
#  }
#}
#
#  attribute_mapping = {
#    email    = "email"
#    username = "sub"
#  }
#}


#provider "aws" {
#  region = "us-east-1"
#}

