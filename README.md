# Testing Terraform with Huawei Cloud Stack

The Terraform file takes several parameters:
- user_name
- password
- domain_name
- tenant-name
- region
- auth_url

You can enter those parameters when asked or put them in a variable file that you name **terraform.tfvars**. Here's an example of such a file.
```
user_name = "joeblog"
password = "the_brown_fox"
domain_name = "mydomain"
tenant_name = "mytenant"
region = "myregion"
auth_url = "https://iam-apigateway-proxy.thecloud.com/v3"
```
Then simply run by using the usual Terraform commands.

Load the huaweicloudstack provider plugin:
````
$ terraform init
````

Plan the deployment:
````
$ terraform plan
````

And finally procure the resources:
````
$ terraform apply
````
