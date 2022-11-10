
provider "aws" {
  region = "eu-west-2"
}

#
# Create a keypair
#
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#
# Create a keypair within AWS using this public key
#
resource "aws_key_pair" "generated_key" {
  key_name   = "awskey"
  public_key = tls_private_key.example.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

#
# Determine what the AMI identifier is for latest Amazon Linux AMI
#
data "aws_ami" "mylinux" {
    most_recent = true

    filter {
        name   = "name"
        values = ["amzn2-ami-kernel-*"]
    }

    owners = ["137112412989"] # Amazon
}

#
# Spin up a master VM using this newly generated key
#
resource "aws_instance" "kube_master" {
  ami           = "${data.aws_ami.mylinux.id}"
  instance_type = "t2.micro"
  key_name      = "awskey"

  tags = {
    Name = "kube_master"
  }

  # Copy the repo definition over
  provisioner "file" {
    source = "kubernetes.repo"
    destination = "/home/ec2-user/kubernetes.repo"
  }

  provisioner "remote-exec" {
    inline = [
      # Turn off SELinux, as it breaks k8s
      "sudo setenforce 0",
      # Setup k8s repo
      "sudo cp /home/ec2-user/kubernetes.repo /etc/yum.repos.d",
      # Install k8s stuff, plus dependencies iproute-tc and containerd
      "sudo yum install -q -y kubelet kubeadm kubectl iproute-tc containerd --disableexcludes=kubernetes",
      # Modprobe
      "sudo modprobe br_netfilter",
      # Turn on ip forwarding
      "echo 1 | sudo tee -a /proc/sys/net/ipv4/ip_forward",
      "echo 1 | sudo tee -a /proc/sys/net/bridge/bridge-nf-call-iptables",
      # Start containerd
      "sudo systemctl start containerd",
      # Initialise.  We've only 1 CPU and <1GB memory, so tell kubeadm to ignore those checks
      "sudo kubeadm init --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem",
    ]
  }

  # prob need to make selinux off permanent with sed cmd ?

  # kubeadm init

  #
  # Credentials which the remote-exec will use
  #
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.example.private_key_openssh
    timeout     = "6m"
  }
}

# 
# spin up some worker VMs
#
resource "aws_instance" "kube_worker" {
  count         = 4
  ami           = "${data.aws_ami.mylinux.id}"
  instance_type = "t2.micro"
  key_name      = "awskey"

  tags = {
    Name = "kube_worker_${count.index}"
  }

  # Copy the repo definition over
  provisioner "file" {
    source = "kubernetes.repo"
    destination = "/home/ec2-user/kubernetes.repo"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ec2-user/kubernetes.repo /etc/yum.repos.d",
      "sudo yum install -q -y kubeadm --disableexcludes=kubernetes",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.example.private_key_openssh
    timeout     = "6m"
  }
}


output "image_id" {
    value = "${data.aws_ami.mylinux.id}"
}
