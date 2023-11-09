resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })
#merge function combine the variable 
#   tags = var.tags   # locals.tf is in same location as main.tf outside of module
# tags = local.project_tags When locals.tf is in vpc folder in the module
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet1_cidr_block
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public_subnet1"
  })
#   tags = var.tags
# tags = local.project_tags
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet2_cidr_block
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public_subnet2"
  })
#   tags = var.tags
# tags = local.project_tags
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet1_cidr_block
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private_subnet1"
  })
#   tags = var.tags
# tags = local.project_tags
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet2_cidr_block
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private_subnet2"
  })
#   tags = var.tags
# tags = local.project_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id         #Attached to vpc

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"       
    gateway_id = aws_internet_gateway.igw.id  #Associate internet gateway with public route table
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}

resource "aws_route_table_association" "public_subnet1_asocciation" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet2_asocciation" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip" {
#   instance = aws_instance.web.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip"
  })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id    #Lunch in public subnet and allow private resource to connect to the internet

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.nat_eip, aws_subnet.public_subnet1]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"       
    gateway_id = aws_nat_gateway.nat_gw.id  #Associate internet gateway with public route table
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt"
  })
}

resource "aws_route_table_association" "private_subnet1_asocciation" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet2_asocciation" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}




# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
 
# }

# resource "aws_subnet" "public_subnet1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "public_subnet1"
#   }
# }

# resource "aws_subnet" "public_subnet2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
#   tags = {
#     Name = "public_subnet2"
#   }
# }

# resource "aws_subnet" "private_subnet1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "private_subnet1"
#   }
# }

# resource "aws_subnet" "private_subnet2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.4.0/24"
#   availability_zone = "us-east-1b"
#   tags = {
#     Name = "private_subnet2"
#   }
# }