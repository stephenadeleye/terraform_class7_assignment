###############################################################################
# security_groups.tf
###############################################################################

# Replace this with your VPC resource reference
# For example, if your VPC resource is: aws_vpc.main, then:
locals {
  # Example "trusted" IP. Replace with a real CIDR, e.g., your office/public IP.
  trusted_ip = "203.0.113.0/24"
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg-london"
  description = "Allow SSH from trusted IPs and HTTP from anywhere"
  vpc_id      = aws_vpc.main.id  # Must match your existing VPC

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg-london"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg-london"
  description = "Allow MySQL from web-sg only"
  vpc_id      = aws_vpc.main.id

  # Inbound MySQL only from the Web SG above
  ingress {
    description             = "MySQL inbound from web-sg"
    from_port               = 3306
    to_port                 = 3306
    protocol                = "tcp"
    security_groups         = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg-london"
  }
}
