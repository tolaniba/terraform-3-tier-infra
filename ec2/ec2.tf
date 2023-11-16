resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  user_data = file("scripts/web-server-setup.sh")   #Use file function to read the file content
  vpc_security_group_ids = [aws_security_group.web_server_sg.id ] # Integrating ec2 with security_groups

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server"
  })
}

resource "aws_security_group" "web_server_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server-sg"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "traffic port"
    from_port        = 80     #HTTP port number
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   #Receive traffic from public or load blancer
  }

  ingress {
    description      = "traffic port"
    from_port        = 443     #HTTPS port number
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   #Receive traffic from public
  }

  ingress {
    description      = "traffic port"
    from_port        = 22     #SSH port number
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   #Receive traffic from public
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-server-sg"
})
}