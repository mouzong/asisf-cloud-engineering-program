resource "aws_vpc" "vpc_02_terraformed" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "vpc-02-terraformed"
  }
}

resource "aws_subnet" "public_subnet_vpc_tf" {
  vpc_id     = aws_vpc.vpc_02_terraformed.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "public-subnet-vpc-tf"
  }
}
