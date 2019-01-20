variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-2"
}

resource "aws_security_group" "defaultsg" {
  name        = "tf.default security group"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# 8080 access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# 8181 access
  ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# HTTPs access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "abulkay"
  public_key = "${file("./abulkay.pub")}"
}

resource "aws_instance" "http-echo" {
  connection {
    # username for our AMI
    user = "ec2-user"

  }

  name			= "tf. http-echo"
  ami           = "ami-01e24be29428c15b2"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.defaultsg.id}"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install docker",
      "sudo usermod -aG docker $USER",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo docker-compose --version",
      "git clone https://github.com/abdulbasitkay/terraform-aws-sample.git",
      "cd terraform-aws-sample",
      "sudo docker-compose up -d"
    ]
  }
}

output "address" {
  value = "${aws_instance.http-echo.public_dns}"
}