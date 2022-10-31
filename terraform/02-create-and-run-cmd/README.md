Create an EC2 instance and run an ansible playbook on it


# Create VM

## Create keypair

```
$ mkdir keys
$ ssh-keygen -q -f keys/aws_terraform -C aws_terraform_ssh_key -N ''
$ 
```

## Create keys.tf

```
$  cat keys/aws_terraform.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8/Htc63WHTm0ooQx0WrpKGW8sMnB52ISwVOHrXs8dcWnGqBwcCRnajj6fkIIK3Xl0tcmKcdq9Tv19BH33fn6oaSBi3vj5tA4vYXII5wSs4JhgLMk+NSK+PNpwZBuoaQVZJ9Q5oocGLJmFVHcuzs+io1j/taaDH0iWm/TtX8mrXIWEOgAuEms8nR99xmcRuV52FPDcjcA8+1Ikn5cMQMnFF1X73kofRg6jCapqr0Oa9acs8BzSH/qhdKYukza6oEFcRfpt0kmvGa2tnp5HuillysGXdvAVYAg2TCJe7bBzRYuWvZYs424f5mkDt0N5eZxCKR+sIXV80H1ulq3WxvAvzzez+ondzB0cYXYt00uDrpJ3ksa2DTJXzLP0efago92TOJHG8YGdy90vZwbRLCoL0H2MxYTE8K9JVrlQFbqm6QZpDxhPLt/5iFAV8/Hkg1kFS9WbmWlL8PWKVjMhtstt/3c/tBLShOCxfkyO91qRt3hQSru1rwcAMGJaL6lNkX0= aws_terraform_ssh_key
$ cat >keys.tf
resource "aws_key_pair" "admin_key" {
  key_name   = "admin_key"
  public_key = ""ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8/Htc63WHTm0ooQx0WrpKGW8sMnB52ISwVOHrXs8dcWnGqBwcCRnajj6fkIIK3Xl0tcmKcdq9Tv19BH33fn6oaSBi3vj5tA4vYXII5wSs4JhgLMk+NSK+PNpwZBuoaQVZJ9Q5oocGLJmFVHcuzs+io1j/taaDH0iWm/TtX8mrXIWEOgAuEms8nR99xmcRuV52FPDcjcA8+1Ikn5cMQMnFF1X73kofRg6jCapqr0Oa9acs8BzSH/qhdKYukza6oEFcRfpt0kmvGa2tnp5HuillysGXdvAVYAg2TCJe7bBzRYuWvZYs424f5mkDt0N5eZxCKR+sIXV80H1ulq3WxvAvzzez+ondzB0cYXYt00uDrpJ3ksa2DTJXzLP0efago92TOJHG8YGdy90vZwbRLCoL0H2MxYTE8K9JVrlQFbqm6QZpDxhPLt/5iFAV8/Hkg1kFS9WbmWlL8PWKVjMhtstt/3c/tBLShOCxfkyO91qRt3hQSru1rwcAMGJaL6lNkX0="
}
$
```

## Create main.tf

```
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
    private_key = file("keys/aws_terraform")
    timeout     = "4m"
  }
}
$
```

## Init / Fmt / Validate / Apply

```
$ terraform init ; terraform validate ; terraform fmt

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.37.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

main.tf
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.app_server will be created
  + resource "aws_instance" "app_server" {
      + ami                                  = "ami-0648ea225c13e0729"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
...
      + key_name                             = "admin_key"
...
  # aws_key_pair.admin_key will be created
  + resource "aws_key_pair" "admin_key" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "admin_key"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + key_type        = (known after apply)
      + public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8/Htc63WHTm0ooQx0WrpKGW8sMnB52ISwVOHrXs8dcWnGqBwcCRnajj6fkIIK3Xl0tcmKcdq9Tv19BH33fn6oaSBi3vj5tA4vYXII5wSs4JhgLMk+NSK+PNpwZBuoaQVZJ9Q5oocGLJmFVHcuzs+io1j/taaDH0iWm/TtX8mrXIWEOgAuEms8nR99xmcRuV52FPDcjcA8+1Ikn5cMQMnFF1X73kofRg6jCapqr0Oa9acs8BzSH/qhdKYukza6oEFcRfpt0kmvGa2tnp5HuillysGXdvAVYAg2TCJe7bBzRYuWvZYs424f5mkDt0N5eZxCKR+sIXV80H1ulq3WxvAvzzez+ondzB0cYXYt00uDrpJ3ksa2DTJXzLP0efago92TOJHG8YGdy90vZwbRLCoL0H2MxYTE8K9JVrlQFbqm6QZpDxhPLt/5iFAV8/Hkg1kFS9WbmWlL8PWKVjMhtstt/3c/tBLShOCxfkyO91qRt3hQSru1rwcAMGJaL6lNkX0="
      + tags_all        = (known after apply)
    }
...
aws_key_pair.admin_key: Creation complete after 0s [id=admin_key]
aws_instance.app_server: Still creating... [10s elapsed]
aws_instance.app_server: Still creating... [21s elapsed]
aws_instance.app_server: Still creating... [31s elapsed]
aws_instance.app_server: Provisioning with 'remote-exec'...
aws_instance.app_server (remote-exec): Connecting to remote host via SSH...
aws_instance.app_server (remote-exec):   Host: 35.178.159.16
aws_instance.app_server (remote-exec):   User: ec2-user
aws_instance.app_server (remote-exec):   Password: false
aws_instance.app_server (remote-exec):   Private key: true
aws_instance.app_server (remote-exec):   Certificate: false
aws_instance.app_server (remote-exec):   SSH Agent: false
aws_instance.app_server (remote-exec):   Checking Host Key: false
aws_instance.app_server (remote-exec):   Target Platform: unix
aws_instance.app_server (remote-exec): Connected!
aws_instance.app_server: Creation complete after 34s [id=i-0ad29229cc0389827]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
$ 
```

# Test

## Check key is setup

```
$  ssh -i keys/aws_terraform ec2-user@35.178.159.16 id
client_global_hostkeys_private_confirm: server gave bad signature for RSA key 0: error in libcrypto
uid=1000(ec2-user) gid=1000(ec2-user) groups=1000(ec2-user),4(adm),10(wheel),190(systemd-journal)
$
```

## Check the hello.txt got created

```
$ ssh -i keys/aws_terraform ec2-user@35.178.159.16 cat hello.txt
client_global_hostkeys_private_confirm: server gave bad signature for RSA key 0: error in libcrypto
helloworld remote provisioner
$
```

