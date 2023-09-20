
resource "aws_instance" "new_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name =    var.key_name //"my-key-ec2" # Insira o nome da chave criada antes.
  subnet_id = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "new_ec2"
    # Insira o nome da instância de sua preferência.
  }
}

resource "aws_eip" "_" {
  //vpc      = true
  instance = aws_instance.new_ec2.id
}
/*
resource "tls_private_key" "_" {
  algorithm = "RSA"
  rsa_bits  = 4096
}*/
/*
resource "aws_key_pair" "_" {
  key_name   = var.key_name
  public_key = tls_private_key._.public_key_openssh
}
*/


resource "aws_security_group" "permitir_ssh_http" {
  name        = "permitir_ssh"
  description = "Permite SSH e HTTP na instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "permitir_ssh_e_http"
  }
}