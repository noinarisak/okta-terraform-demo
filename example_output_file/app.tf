# Very simple Okta Org example configuration for OAuth.

# https://www.terraform.io/docs/configuration/variables.html
variable "org_name" {}
variable "api_token" {}
variable "base_url" {}

terraform {
  required_providers {
    okta = {
      version = "= 3.5.0"
      source  = "oktadeveloper/okta"
    }
    local = {
      version = "= 1.4.0"
      source  = "hashicorp/local"
    }
    template = {
      version = "= 2.1.2"
      source  = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}

# More https://www.terraform.io/docs/configuration/providers.html and https://www.terraform.io/docs/providers/okta/index.html
provider "okta" {
  org_name  = var.org_name
  api_token = var.api_token
  base_url  = var.base_url
  version   = "~> 3.0"
}

# More https://www.terraform.io/docs/configuration/resources.html
resource "okta_app_oauth" "example" {
  label          = local.app_name
  type           = "browser"
  grant_types    = ["implicit"]
  redirect_uris  = ["http://${local.app_name}.local/implicit/callback"]
  response_types = ["token", "id_token"]
  issuer_mode    = "ORG_URL"
}

resource "okta_auth_server" "example" {
  audiences   = ["api://main.${local.app_name}"]
  description = "main"
  name        = "main.${local.app_name}"
}

# More https://www.terraform.io/docs/providers/template/index.html
data "template_file" "exampleConfiguration" {
  template = "${file("${path.module}/example.dotenv.template")}"
  vars = {
    client_id      = "${okta_app_oauth.example.client_id}"
    client_secret  = "${okta_app_oauth.example.client_secret}"
    auth_server_id = "${okta_auth_server.example.id}"
    domain         = "${var.org_name}.${var.base_url}"
  }
}

# More https://www.terraform.io/docs/providers/local/r/file.html
resource "local_file" "exampleDotenv" {
  content  = data.template_file.exampleConfiguration.rendered
  filename = "${path.module}/example.env"
}

# More https://www.terraform.io/docs/configuration/outputs.html
output "okta_app_oauth_client_id" {
  value = "${okta_app_oauth.example.client_id}"
}

output "okta_app_oauth_client_secret" {
  value = "${okta_app_oauth.example.client_secret}"
}

output "okta_auth_server_id" {
  value = "${okta_auth_server.example.id}"
}

output "okta_auth_server_issuer_uri" {
  value = "https://${var.org_name}.${var.base_url}/oauth2/${okta_auth_server.example.id}"
}

# More https://www.terraform.io/docs/configuration/locals.html
locals {
  app_name = "tf-output-file-demo"
}
