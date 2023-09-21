
resource "aws_instance" "new_ec2_jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name =    "sshkey-key"//  var.key_name //"my-key-ec2" # Insira o nome da chave criada antes.
  subnet_id = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.security_group_jenkins.id]
  associate_public_ip_address = true
  user_data ="../data/data_jenkins.sh"     
  tags = {
    Name = "new_ec2_jenkins"
    # Insira o nome da instância de sua preferência.
  }
}


resource "aws_security_group" "security_group_jenkins" {
  name        = "permitir_ssh_jenkins"
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
    from_port   = 8080
    to_port     = 8080
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
    Name = "security_group_jenkins"
  }
}