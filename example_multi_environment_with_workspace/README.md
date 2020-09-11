# Example Demo: Multi Environment With Terraform Workspace

> NOTE: You must complete the [Quick Start](../README.md#quick-start) instructions for this demo.

## Setup the example

1. Copy and rename `okta.tfvars.sample` to `{example_folder}/config/okta.tfvars`. Preform this twice, one for staging and production.

```bash
# Example
cp okta.tfvars.sample example_multi_environment_with_workspace/config/stg.okta.tfvars && \
  cp okta.tfvars.sample example_multi_environment_with_workspace/config/prd.okta.tfvars
```

2. Update the config files with the Okta Org configuration values.

```bash
# stg.okta.tfvars
org_name  = "dev-302083"
base_url  = "okta.com"
api_token = "xxxx"

# prd.okta.tfvars
org_name  = "dev-302083"
base_url  = "okta.com"
api_token = "xxxx"
```

## Run it!

> NOTE: In `terraform plan` step and following steps you'll notice that we are using `-lock=false` option. The option `-lock` by default is true. This repo is for demoing purpose, and setting `-lock=false` let us by pass any locking warning/error. In a real world situation one should use [terraform backend](https://www.terraform.io/docs/backends/index.html) to store the state file using services like AWS s3 & DynamoDB as a locking mechanism. More [details](https://www.terraform.io/docs/state/locking.html) about Terraform State and Locking.

Create/Update Action

```bash

# Root of the project
$ cd {example_folder}

# Validate config tfvars files
$ cat config/(stg|prd).okta.tfvars

i.e.
org_name  = "dev-123456"
base_url  = "okta.com"
api_token = "00uhfN0..."

# Setup up workspace for staging and production. More https://www.terraform.io/docs/commands/workspace/index.html
$ terraform workspace new stg && terraform workspace new prd

# NOTE: 'default' is workspace that is always present. More https://www.terraform.io/docs/state/workspaces.html
$ terraform workspace list

i.e. Output
  default
* prd
  stg

# Select staging workspace
$ terraform workspace select stg

# Confirm that workspace is set to stg. Mark with an asterisk.
$ terraform workspace list
i.e.
  default
  prd
* stg

-or-
$ terraform workspace show
stg

# Initialize all the providers/plugin
$ terraform init

# Validate the terraform scripts
$ terraform validate

# See what will be changing by executing terraform plan and tfplan file. NOTE: In a real word situation option `-lock` default is true. Since this demo and local execute we need this flag to by pass terraforming locking warning/error.

$ terraform plan \
   -var-file=config/stg.okta.tfvars \
   -out=stg.okta.tfplan \
   -lock=false

i.e. Output
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # okta_app_oauth.example will be created
  + resource "okta_app_oauth" "example" {
      + auto_key_rotation          = true
      + auto_submit_toolbar        = false
      + client_id                  = (known after apply)
      + client_secret              = (sensitive value)
      + grant_types                = [
          + "implicit",
        ]
      + hide_ios                   = true
      + hide_web                   = true
      + id                         = (known after apply)
      + issuer_mode                = "ORG_URL"
      + label                      = "acme-inc"
      + name                       = (known after apply)
      + omit_secret                = false
      + redirect_uris              = [
          + "http://acme-inc.local/oidc",
        ]
      + response_types             = [
          + "id_token",
          + "token",
        ]
      + sign_on_mode               = (known after apply)
      + status                     = "ACTIVE"
      + token_endpoint_auth_method = "client_secret_basic"
      + type                       = "browser"
    }
...

# Apply the plan!
$ terraform apply -lock=false "stg.okta.tfplan"

# Generate file by terraform. Notice that terraform.tfstate.d/stg/ directory contains state file.
$ tree

i.e
├── app.tf
├── config
│   ├── prd.okta.tfvars
│   └── stg.okta.tfvars
├── stg.okta.tfplan
└── terraform.tfstate.d
    ├── prd
    └── stg
        └── terraform.tfstate
        └── terraform.tfstate.backup # if you ran terraform apply again

# Review updates by going to your Okta Org that represent your staging environment, Applications and Authorization Server screens.

# Provision the same app.tf to next Okta Org (i.e. Production)

# Switch to prd workspace
$ terraform workspace select prd

# Validate you are on prd workspace
$ terraform workspace show

i.e.
prd

# Re-execute commands not targeting prd.okta.tfvars
$ terraform init

$ terraform validate

$ terraform plan \
   -var-file=config/prd.okta.tfvars \
   -out=prd.okta.tfplan \
   -lock=false

$ terraform apply -lock=false "prd.okta.tfplan"

# Generated by terraform directory should now look similar to this. A new state file is located at terraform.tfstate.d/prd/ directory.
$ tree

i.e
├── app.tf
├── config
│   ├── prd.okta.tfvars
│   └── stg.okta.tfvars
├── prd.okta.tfplan
├── stg.okta.tfplan
└── terraform.tfstate.d
    ├── prd
        └── terraform.tfstate        # <-- NEW!
        └── terraform.tfstate.backup # if you run terraform apply again
    └── stg
        └── terraform.tfstate
        └── terraform.tfstate.backup # if you run terraform apply again
```

>(Optional)
Inspect `terraform.tfstate` json file in your favorite editor. This file should never by manually updated and for advance usage please refer to [`terraform state`](https://www.terraform.io/docs/commands/state/index.html) command. This state file is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. More [details](https://www.terraform.io/docs/state/locking.html) about Terraform State.

Change/Update Action

```bash
# Update the app.tf
i.e
vi app.tf # preferred editor

# Re-execute init, validate, plan and apply commands.
```

Destroy Action

```bash
# Validate that you still on the prd workspace
$ terraform workspace show
i.e.
prd

# Destroy Okta Org resources representing production
$ terraform destroy \
    -var-file=config/prd.okta.tfvars \
    -lock=false

# You will be prompted to confirm destroy action.
i.e.
...
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

# Switch stg workspace
$ terraform workspace select stg

# Validate active workspace
$ terraform workspace show
i.e.
stg

# Destroy Okta Org resources representing staging
$ terraform destroy \
    -var-file=config/stg.okta.tfvars \
    -lock=false

# You will be prompted to confirm destroy action.
i.e.
...
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

# (Optional) Review terraform.tfstate in 'terraform.tfstate.d' directory. Only terraform state header should appear.
cat example_multi_environment_with_workspace/terraform.tfstate.d/stg

i.e.
{
  "version": 4,
  "terraform_version": "0.12.9",
  "serial": 6,
  "lineage": "7b1e2cea-6589-2603-e5d3-467b2603284f",
  "outputs": {},
  "resources": []
}

# Review destroy by going to both your Okta Org, Applications and Authorization Server screens.
```

Congrats! :tada:

Learn [more](../README.md##more-information).
