data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Bastion
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.allow_ssh.id]
  key_name          =   aws_key_pair.k8_ssh.key_name
  ##https://github.com/hashicorp/terraform/issues/30134
  user_data = <<-EOF
                #!bin/bash
                echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
                systemctl reload sshd
                echo "${tls_private_key.ssh.private_key_pem}" >> /home/ubuntu/.ssh/id_rsa
                chown ubuntu /home/ubuntu/.ssh/id_rsa
                chgrp ubuntu /home/ubuntu/.ssh/id_rsa
                chmod 600   /home/ubuntu/.ssh/id_rsa
                echo "starting ansible install"
                apt-add-repository ppa:ansible/ansible -y
                apt update
                apt install ansible -y
                EOF

  tags = {
    Name = "Bastion"
  }
}

#Master
resource "aws_instance" "masters" {
  count         = var.master_node_count
  #count = var.instances_per_subnet * length(module.vpc.private_subnets)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.master_instance_type
  subnet_id = "${element(module.vpc.private_subnets, count.index)}"
  #subnet_id    = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  key_name      =   aws_key_pair.k8_ssh.key_name
  security_groups = [aws_security_group.k8_nondes.id, aws_security_group.k8_masters.id]

  tags = {
    Name = format("Master-%02d", count.index + 1)
  }
}

#Worker
resource "aws_instance" "workers" {
  count         = var.worker_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.worker_instance_type
  subnet_id = "${element(module.vpc.private_subnets, count.index)}"
  key_name          =   aws_key_pair.k8_ssh.key_name
  security_groups = [aws_security_group.k8_nondes.id, aws_security_group.k8_workers.id]

  tags = {
    Name = format("Worker-%02d", count.index + 1)
  }
}
