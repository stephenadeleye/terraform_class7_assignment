###############################################################################
# internet_gateway.tf
###############################################################################

# 1) Internet Gateway attached to the VPC
#resource "aws_internet_gateway" "igw" {
#  vpc_id = vpc-0b75c3ed77d8ef978  # Replace with your VPC resource reference
#
 # tags = {
  #  Name = "my-internet-gateway"
  #}
#}

# 2) Configure a NAT Gateway in the public subnet
#    a) Allocate an Elastic IP (EIP) for the NAT Gateway
#resource "aws_eip" "nat_eip" {
  # domain = "vpc" is used in place of deprecated 'vpc = true'
#  domain    = "vpc"
 # depends_on = [aws_internet_gateway.igw]  # Ensures IGW is created first
#
 # tags = {
  #  Name = "my-nat-eip"
#  }
#}

#    b) Create the NAT Gateway using the allocated EIP in a public subnet
#resource "aws_nat_gateway" "nat_gw" {
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id     = subnet-05692c20091a0a311  # Replace with your public subnet resource reference
#
#  tags = {
#    Name = "my-nat-gateway"
#  }
#}
