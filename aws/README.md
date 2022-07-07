
# using ENVIRONMENT VARIABLES for credentials
 
```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
```

# want to save a configuration and apply on aws

```
$ terraform plan -out AnyName.out
$ terraform apply "AnyName.out"
```
In this way you can have multiple configurations that can be used later on

# Commands and use

### terraform init:
 Setup a new terraform project for this file.
### terraform apply:
 Setup the infrastructure as it’s defined in the .tf file.
### terraform destroy:
 Tear down everything that terraform created.
### terraform state list:
 Show everything that was created by terraform.
### terraform state show aws_instance.web_instance:
 Show the details about the ec2 instance that was deployed.
 this is used to get ip of instance deployed