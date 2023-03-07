

resource "aws_security_group" "sg_my_server" {
  name        = "ssh"
  description = "enable port 22 for ssh coonections"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0", ]
    protocol    = "tcp"
  }

  ingress {
    description = "Open port 5000"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = ["0.0.0.0/0", ]
    protocol    = "tcp"
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "my_server" {
  ami                         = "ami-0557a15b87f6559cf"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.sg_my_server.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.my_server.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.my_server.public_ip}, --private-key ${local.private_key_path} api.yaml"
  }

}

resource "aws_eip" "my_server_public_ip" {
  instance = aws_instance.my_server.id
  vpc      = true
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}
