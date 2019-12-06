#Very simple example.

variable "org_name" {}
variable "api_token" {}
variable "base_url" {}

provider "okta" {
  org_name  = "${var.org_name}"
  api_token = "${var.api_token}"
  base_url  = "${var.base_url}"
  version   = "~> 3.0"
}

resource "okta_app_oauth" "example" {
  label          = "${var.app_name}"
  type           = "browser"
  grant_types    = ["implicit"]
  redirect_uris  = ["http://${var.demo_app_name}.local/oidc"]
  response_types = ["token", "id_token"]
  issuer_mode    = "ORG_URL"
}

resource "okta_auth_server" "example" {
  audiences   = ["api://main.${var.app_name}"]
  description = "main"
  name        = "main.${var.app_name}"
}
