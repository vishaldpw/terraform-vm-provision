## main.tf
## user created is demouser // password: demouser
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}


  resource "aws_instance" "master" {
  ami           = "ami-041d6256ed0f2061c"
  instance_type = "t2.micro"
  key_name               = "mumbai-key"
   user_data = <<-EOF
  #!/bin/bash
  echo "Setting up user & password"
  sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo useradd -m -p sace.HAhPGPcU demouser
  sudo usermod -G wheel demouser
  sudo wget https://www.apachefriends.org/xampp-files/8.0.12/xampp-linux-x64-8.0.12-0-installer.run
  sudo chmod +x xampp-linux-x64-8.0.12-0-installer.run
  sudo ./xampp-linux-x64-8.0.12-0-installer.run --mode unattended --launchapps 0
  sudo sed -i 's/local/all granted/g' /opt/lampp/etc/extra/httpd-xampp.conf
  sudo /opt/lampp/lampp restart
  sudo wget https://github.com/jenil/simple-ecomme/archive/refs/heads/master.zip
  sudo unzip master.zip
  sudo cp -av simple-ecomme-master /opt/lampp/htdocs/
  EOF
  vpc_security_group_ids = ["sg-06960570ea99dd450"]
  tags = {
    Name = "XAMPP-2"
 }
}
