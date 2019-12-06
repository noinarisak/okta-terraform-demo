# Okta :heart: Terraform
Simple Proof of Concept showcasing Okta and Terraform implementation.


## ToC
* [Pre-Req](#pre-req)
* [Quick Start](#quick-start)
* [More Informaion](#more-information)

## Pre Req

* Okta Org/Tenant
* Terraform and Terraform Provider

## Quick Start

Setup developer Okta Org and create a API Token.

1. Setup developer Okta Org at [Developer.okta.com](https://developer.okta.com/).
2. Active Okta Org and go to the Dashboad.
3. On the Dashboard screen, navigate `API` menu and select `Tokens`.
4. On the API screen, click `Create Token` and name your API Token.
5. Copy and store the generated token so you can use this `backend.config` file later.
6. Make note of your Okta Org url. (ie. `dev-302083.okta.com`) you need this later too.

Copy and rename `backend.config.sample` to `backend.config`. Update the config file with the Okta Org configuration values.

```
# Example
mv backend.config.sample backend.config
```
### Old School (aka. Manually)

### Lazy Way
Help
```
make help
```

Create, Review and Apply
```
# Create terraform plan to apply
make create 

# Review
...

# Execute terraform plan
make apply
```

Cleanup 
```
make destory
```

## More information

* Okta
  * [Developer.okta.com](https://developer.okta.com)
 
* Terraform
  * [Introduction to Terraform](https://www.terraform.io/intro/index.html)
  * [Terraform Tutorial](https://learn.hashicorp.com/terraform)
  * [Terraform Okta Provider](https://www.terraform.io/docs/providers/okta/index.html)
  * [Terraform Provider Ecosystem](https://www.terraform.io/docs/providers/index.html)
