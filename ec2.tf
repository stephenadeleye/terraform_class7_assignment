###############################################################################
# ec2.tf
###############################################################################

# 1) Data source to fetch the latest Amazon Linux 2 AMI in eu-west-2
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 2) Two EC2 instances for the web servers in the public subnets
resource "aws_instance" "web_server_a" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"

   # Specify your key pair here:
  key_name = "cba_keypair"

  # Attach to a public subnet
  subnet_id = aws_subnet.public_subnet_a.id
  
  # Optional: If you have a security group for web servers, reference it here.
  # Example:
  # vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Automatically install & configure Apache on first boot
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to the Web Server A</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "web-server-a"
  }
}

resource "aws_instance" "web_server_b" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"

  # Specify your key pair here:
  key_name = "cba_keypair"

  # Attach to the other public subnet
  subnet_id = aws_subnet.public_subnet_b.id
vpc_security_group_ids = [aws_security_group.web_sg.id]
  # Optional: If you have a security group for web servers, reference it here.
  # Example:
  # vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Same user_data for simplicity (or alter the message)
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to the Web Server B</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "web-server-b"
  }
}

# 3) One EC2 instance for the MySQL database in the private subnet
resource "aws_instance" "db_server" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"

   # Specify your key pair here:
  key_name = "cba_keypair"

  # Attach to the private subnet
  subnet_id = aws_subnet.private_subnet_a.id

  # Optional: If you have a security group for the DB, reference it here.
  # Example:
  # vpc_security_group_ids = [aws_security_group.db_sg.id]

  # Example user_data if you want to bootstrap MySQL on this instance:
  # user_data = <<-EOF
  #   #!/bin/bash
  #   sudo yum update -y
  #   sudo yum install mysql-server -y
  #   sudo systemctl start mysqld
  #   sudo systemctl enable mysqld
  #   # Additional setup commands for MySQL
  # EOF

  tags = {
    Name = "db-server"
  }
}
