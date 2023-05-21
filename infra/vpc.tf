## VPC
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"

    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "ansible_prcatice_vpc"
    }
}

## Internet gateway
resource "aws_internet_gateway" "main_gw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "ansible_practice_gw"
    }
}

## Public subnet
resource "aws_subnet" "main_public_subnet" {
    vpc_id = aws_vpc.main_vpc.id

    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = join("",[var.aws_region,"a"])

    tags = {
        Name = "ansible_practice_public_subnet"
    }
}

## Route Table 
resource "aws_route_table" "main_rt" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_gw.id
    }

    tags = {
        Name = "ansible_public_rt"
    }
}

## Mapping Table
resource "aws_route_table_association" "main_public_mapping" {
    subnet_id = aws_subnet.main_public_subnet.id
    route_table_id = aws_route_table.main_rt.id
}