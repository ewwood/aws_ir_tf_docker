#Storing just resources in main.tf

resource "aws_security_group" "aws_ir_docker-sg" {
  name        = "aws_ir_docker_sg"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aws_ir_docker" {
  ami           = "ami-0d8dc90079e445007" # This ami is for Debian Stretch
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.aws_ir_docker-sg.id]
  #subnet_id    = #enter the subnet of the compromised instance here and uncomment the line.

  connection {
    host        = self.public_ip #did not see this in documentation but found solution here: https://github.com/hashicorp/terraform/issues/20816
    user        = "admin" #ec2-user is the default user for amazon linux and admin is default for debian
    private_key = file(var.private_key_path)
  }

  # docker installer file to aws instance
  provisioner "file" {
    source      = "scripts/"
    destination = "/home/admin/"
  }
  provisioner "remote-exec" {
    inline = [

      #Install Docker and pull aws_ir_docker image.
      "sudo chmod 700 install_docker.sh",
      "./install_docker.sh"

      
    ]
  }
}
