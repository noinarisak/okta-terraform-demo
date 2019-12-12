# Example Demo: Output Environment Variable file

> NOTE: You must complete the [Quick Start](../README.md#quick-start) instructions for this demo.

## Setup the example.

1. Copy and rename `okta.tfvars.sample` to `{example_folder}/config/okta.tfvars`.

```
# Example
cp okta.tfvars.sample example_output_file/config/okta.tfvars
```

2. Update the config file with the Okta Org configuration values.

```
# okta.tfvars
org_name  = "dev-302083"
base_url  = "okta.com"
api_token = "xxxx"
```

## Run it!

> NOTE: In `terraform plan` step we passing `-lock=false`. In a real word situation option `-lock` default is true. Since this demo and local execution we need this flag to set to `false` to by pass terraforming locking warning/error. More [details](https://www.terraform.io/docs/state/locking.html) about Terraform State and Locking.

Create/Update Action
```bash

# Root of the project
$ cd {example_folder}

# Validate config tfvars files
$ cat config/okta.tfvars

i.e.
org_name  = "dev-123456"
base_url  = "okta.com"
api_token = "00uhfN0..."

# Initatialize all the providers/plugin
$ terraform init

# Validate the terraform scripts
$ terraform validate

# See what will be changing by executing terraform plan and tfplan file. NOTE: In a real word situation option `-lock` default is true. Since this demo and local execute we need this flag to by pass terraforming locking warning/error.

$ terraform plan \
   -var-file=config/okta.tfvars \
   -out=okta.tfplan \
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
$ terraform apply -lock=false "okta.tfplan"

# Generate file by terraform
$ ls -l

i.e
config
app.tf
example.dotenv.template
example.env
okta.tfplan
terraform.tfstate
terraform.tfstate.backup # if you ran terraform appy (updates) or destory action.

# Generate *.env file was created
$ cat example.env

# Review updates by going to your Okta Org, Applications and Authorization Server screens.
```

> (Optional)
Inspect `terraform.tfstate` json file in your favorite editor. This file should never by manaully updated and for advance usage please refer to [`teraform state`](https://www.terraform.io/docs/commands/state/index.html) command. This state file is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. More [details](https://www.terraform.io/docs/state/locking.html) about Terraform State.

Change/Update Action

```bash
# Update the app.tf
i.e
vi app.tf # preferred editor

# Re-execute init, validate, plan and apply commands.
```

Destory Action

```bash
$ terraform destroy \
    -var-file=config/okta.tfvars \
    -lock=false

# You will be prompted to confirm destory action.
i.e.
...
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

# Review terraform.tfstate. Only terraform state header should appear.
# cat terraform.tfstate

i.e.
{
  "version": 4,
  "terraform_version": "0.12.9",
  "serial": 6,
  "lineage": "7b1e2cea-6589-2603-e5d3-467b2603284f",
  "outputs": {},
  "resources": []
}

# Review destroy by going to your Okta Org, Applications and Authorization Server screens.
```

Congrats! :tada:

Learn [more](../README.md##more-information).