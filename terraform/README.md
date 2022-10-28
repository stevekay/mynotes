# Terraform

## Install Terraform

Per https://www.terraform.io/downloads

```
$ sudo yum install -y yum-utils
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
$ sudo yum -y install terraform
```

## Install AWS CLI

```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
You can now run: /usr/local/bin/aws --version
$ aws --version
aws-cli/2.8.6 Python/3.9.11 Linux/5.14.0-70.26.1.el9_0.x86_64 exe/x86_64.rhel.9 prompt/off
$
```

## Setup AWS credentials

