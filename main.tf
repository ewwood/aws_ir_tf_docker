#Storing just resources in main.tf

#key pair
resource "aws_key_pair" "aws_ir_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "aws_ir_docker-sg" {
  name = "aws_ir_docker_sg"

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

data "aws_ami" "amazon-linux-2-ami" {
  most_recent = true
  owners      = ["amazon"] # AWS

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "aws_ir_docker" {
  #  ami                    = "ami-0d8dc90079e445007"                        # This ami is for Debian Stretch
  ami                    = "${data.aws_ami.amazon-linux-2-ami.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.aws_ir_auth.id}"
  vpc_security_group_ids = ["${aws_security_group.aws_ir_docker-sg.id}"]

  #subnet_id    = #enter the subnet of the compromised instance here and uncomment the line.

  # docker installer file to aws instance
  user_data = "${file("scripts/install_docker.sh")}"
}
