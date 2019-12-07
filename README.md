# Okta :heart: Terraform
Simple demo showcasing Okta and Terraform implementation.


## ToC
* [Pre-Req](#pre-req)
* [Quick Start](#quick-start)
* [More Informaion](#more-information)

## Pre Req

* Okta Org/Tenant
* Terraform and Terraform Okta Provider/Plugin

## Quick Start

### Tools

Terreform CLI instructions can be found [here](https://learn.hashicorp.com/terraform/getting-started/install.html) but since the Okta Provider is still *Community* status the binary will NOT automatically be pulled in by `terraform` cli like aws, gcp, etc.

Okta Provider instructions:

* WARNING: `terraform` cli  must be installed
* Download the latest plugin [here](https://github.com/articulate/terraform-provider-okta/releases), selecting the zip file associated with your OS and unzip. (ie. `terraform-provider-okta-darwin-amd64.zip` for MacOS)
* Move the binary file to the your `~/.terraform.d/plugins` on MacOS/Linux or `%APPDATA%\terraform.d\plugins` on Windows.

### Setup Steps for Demo

Setup a developer Okta Org and create a API Token.

1. Setup developer Okta Org at [developer.okta.com](https://developer.okta.com/).
2. Active your Okta Org and then go to the Dashboad.
3. On the Dashboard screen, navigate `API` menu and select `Tokens`.
4. On the API screen, click `Create Token` and name your API Token.
5. Copy and store the generated token so you can use this `backend.config` file later.
6. Make note of your Okta Org url. (ie. `dev-302083.okta.com`) you need this later too.

Setup the example.

1. Copy and rename `okta.tfvars.sample` to `okta.tfvars`. 

```
# Example
mv okta.tfvars.sample okta.tfvars
```

2. Update the config file with the Okta Org configuration values.

```
# okta.tfvars
org_name  = "dev-302083"
base_url  = "okta.com"
api_token = "xxxx"
```


### Run it!

```
# Show version
terraform version

# Initialize
terraform init

# What will happen. NOTE: '-lock=false' is only for demo. Remote state and Locking is recommended for resources.
terraform plan -var-file=okta.tfvars -out=okta.tfpan -lock=false

# Make it happen
terraform apply okta.tfplan

# Go and review your Okta org
...

# Update the app.tf 
...

# Re-execute init, plan and apply
terraform init
terraform plan
terraform apply


# Clean up
terraform init
terraform plan
terraform destory
```

## More information

* Okta
  * [Developer.okta.com](https://developer.okta.com)
  * [Okta + Terraform](https://www.okta.com/blog/2019/08/better-together-using-the-okta-integration-with-hashicorp-terraform)
 
* Terraform
  * [Introduction to Terraform](https://www.terraform.io/intro/index.html)
  * [Terraform Tutorial](https://learn.hashicorp.com/terraform)
  * [Terraform Okta Provider](https://www.terraform.io/docs/providers/okta/index.html)
  * [Terraform Provider Ecosystem](https://www.terraform.io/docs/providers/index.html)
  * [Third-party Plugins Install](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins)
