provider "aws" {
  region     = "us-west-2"
}

resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = "${file(var.public_deploy_key)}"
}

resource "aws_instance" "example" {
  ami                    = "ami-0bc06212a56393ee1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "${aws_key_pair.ec2key.key_name}"
  associate_public_ip_address = true
  
  connection {
    type     = "ssh"
    user     = var.ssh_user
    host     = "${self.public_ip}"
    private_key = "${file(var.private_deploy_key)}"
  }

  provisioner "remote-exec" {
      inline = [
          "sudo yum install -y docker",
          "sudo service docker start",
          "sudo docker run -d -p 80:5000 warolv/python-flask-sample-app:latest",
      ]
  }

  tags = {
    Name = "flask-app"
  }
}

resource "aws_security_group" "instance" {
  name = "flask-app-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}