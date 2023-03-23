locals {
    cidr_block = var.cidr_block
    public_network= var.public_network
    private_network = var.private_network
}


resource "aws_vpc" "vpc" {
    cidr_block = local.cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "${var.Name}"
        Project = var.Project
        Env = var.Environment
        } 
}

# public subnet

resource "aws_subnet" "public_network" {
    count = length(var.public_network)
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
    count = length(var.public_network)
    subnet_id = aws_subnet.public_network[count.index].id
    route_table_id = aws_route_table.public.id
}

#private subnet
resource "aws_subnet" "private_network" {
    count = length(var.private_network)
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
}
#private association

resource "aws_route_table_association" "private" {
    count = length(var.private_network)
    subnet_id = aws_subnet.private_network[count.index].id
    route_table_id = aws_route_table.private.id
}


# ISP
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc.id
    tags = merge({
        Name = var.Name
        Project = var.Project
        Env = var.Environment
    }
    )
}



# nat gateway
resource "aws_eip" "eip" {
    count = length(var.public_network)
    vpc = true
}

resource "aws_nat_gateway" "nat" {
    depends_on = [aws_internet_gateway.IGW]
    count = length(var.public_network)

    allocation_id = aws_eip.eip[count.index].id
    subnet_id = aws_subnet.public_network[count.index].id
}




# route table private
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = merge({
        Name = var.Name
        Project = var.Project
        Env = var.Environment
    }
    )
}


resource "aws_route" "private" {
    count = length(var.private_network)
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
}




# route table public
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    tags = merge({
        Name = var.Name
        Project = var.Project
        Env = var.Environment
    }
    )
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
}