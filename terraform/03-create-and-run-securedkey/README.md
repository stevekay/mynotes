Create an AWS instance, with keypair, but avoid leaving the keypair in a file

# create keypair

```
$ mkdir keys
$ ssh-keygen -q -f keys/aws_terraform -C aws_terraform_ssh_key -N ''
$
```

# place keypair into environment variables

```
$ export TF_VAR_PRIVATEKEY=$(cat keys/aws_terraform)
$ export TF_VAR_PUBLICKEY=$(cat keys/aws_terraform.pub)
$ rm -rf keys
$

```

# files

```
$ cat variables.tf
variable "PRIVATEKEY" { default = "" }
variable "PUBLICKEY" { default = "" }
$ cat keys.tf
resource "aws_key_pair" "admin_key" {
  key_name   = "admin_key"
  public_key = var.PUBLICKEY
}
$ cat main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0648ea225c13e0729"
  instance_type = "t2.micro"
  key_name      = "admin_key"

  tags = {
    Name = "ExampleAppServerInstance"
  }

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = var.PRIVATEKEY
    timeout     = "4m"
  }
}
$
```

# create

```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 4.16"...
- Installing hashicorp/aws v4.37.0...
- Installed hashicorp/aws v4.37.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
$ terraform validate ; terraform fmt
Success! The configuration is valid.

keys.tf
main.tf
variables.tf
$
```

# apply

```
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.app_server will be created
  + resource "aws_instance" "app_server" {
      + ami                                  = "ami-0648ea225c13e0729"
...
Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_key_pair.admin_key: Creating...
aws_instance.app_server: Creating...
aws_key_pair.admin_key: Creation complete after 0s [id=admin_key]
aws_instance.app_server: Still creating... [10s elapsed]
aws_instance.app_server: Still creating... [20s elapsed]
...
aws_instance.app_server (remote-exec): Connected!
aws_instance.app_server: Creation complete after 41s [id=i-02289a4f610afc15a]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
$
```
