terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.token
  api_version = "v4beta"
}

resource "linode_instance" "mgmtInstance"{
label = "managementInstance"
image = "linode/debian11"
region = "us-southeast"
type = "g6-nanode-1"
root_pass = var.root_pass
private_ip = true
authorized_keys = [linode_sshkey.instancekey.ssh_key]

  provisioner "file"{
    source = "../bash-scripts/instance.sh"
    destination = "/tmp/instance.sh"
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }
  }

  /*Copying all repo files to be used by remote machine*/
   provisioner "file"{ 
    source = "../clusterstf"
    destination = "/root/"
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }
  }

    provisioner "remote-exec"{
    inline = [
      "export LINODE_TOKEN=${var.token}",
      "echo ${var.token} >> pat_token",
      "source ~/.bashrc",
      "chmod +x /tmp/instance.sh",
      "/tmp/instance.sh",
      "sleep 1"
    ]
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }

  }

}

resource "linode_sshkey" "instancekey" {
  label = "instancekey"
  ssh_key = chomp(file("../ssh-keys/instance.pub"))
}


variable "token"{}
variable "root_pass"{}