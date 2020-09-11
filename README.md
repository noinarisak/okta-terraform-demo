# Okta :heart: Terraform

Simple demos showcasing Okta and Terraform implementation. The intended audience for this repo are for practitioners who are new to `Terraform` but familiar with Okta. Please review this [introduction on Terraform](https://www.terraform.io/intro/index.html) and of course more info on [Okta](https://developer.okta.com/).

## Table of Contents

* [Pre-Req](#pre-req)
* [Quick Start](#quick-start)
* [More Information](#more-information)

## Pre Req

* Okta Tenant - Free Development tenant [here](https://developer.okta.com/).
* Terraform - Install docs [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) and introduction [here](https://www.terraform.io/intro/index.html).

## Quick Start

### Tools

Validate install:

```bash
# Show version
$ terraform version

ie.
Terraform v0.13.x
...

# List help details
$ terraform help
```

### Setup Steps for Each Demo

Setup a developer Okta Org and create a API Token.

1. Setup developer Okta Org at [developer.okta.com](https://developer.okta.com/).
2. Activate your Okta Org and then go to the Dashboard.
3. On the Dashboard screen, navigate `API` menu and select `Tokens`.
4. On the API screen, click `Create Token` and name your API Token.
5. Copy and store the generated token so you can use this `backend.config` file later.
6. Make note of your Okta Org url. (ie. `dev-302083.okta.com`) you need this later too.

## Example Demos

* [Simple Demo](./example_simple/README.md) - Very simple provisioning of Okta Org.
* [Output File Demo](./example_output_file/README.md) - Show case generating environment variable (*.env) for your application that is tied to your Okta Org.
* [Multi Environment Demo](./example_multi_environment_with_workspace/README.md) - Show case how to use `terraform workspace` to management multiple Okta Orgs. (i.e. Development, Staging, Pre-Production and Production). For this demo please repeat [Setup Steps for Each Demo](#setup-steps-for-each-demo) to represent the different environments.

## Issues/Bugs or Features

Please submit Issues/Bugs/Features using [GitHub Issues](https://github.com/noinarisak/okta-terraform-demo/issues) page and clicking on `New issue` button.

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

* Additional Articles and Blogs
  * [Deeper walk-though with Okta + Terraform](https://github.com/articulate/terraform-provider-okta-demos) Many thanks to Articulate and [quantumew](https://github.com/quantumew) :tada:
  * [Better together using Okta Integration...](https://www.okta.com/blog/2019/08/better-together-using-the-okta-integration-with-hashicorp-terraform/)
  * [Managing Multiple Okta Instances with Terraform Cloud](https://developer.okta.com/blog/2020/02/03/managing-multiple-okta-instances-with-terraform-cloud)
