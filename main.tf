terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

# specify your provider

provider "aws" {
    region = "eu-west-2"
  
}

# provide resourses for vpc

resource "aws_vpc" "obam_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "obam_vpc"
    }
  
}

# intall internet gateway

resource "aws_internet_gateway" "obam_internet_gateway" {
    vpc_id = aws_vpc.obam_vpc
    tags = {
      Name = obam_internet_gateway
    }
  
}

# provision the rout table resopurses

resource "aws_route_table" "obam-route-table-public" {
    vpc_id = aws_vpc.obam_vpc

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.obam_internet_gateway.id
    }

    tags = {
      Name = bam-route-table-public
    }
  
}

# configure first public subnet 

resource "aws_subnet" "obam-public-subnet1" {
    vpc_id = aws_vpc.obam_vpc
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = true


    tags = {
      Name = obam-public-subnet1
    }
  
}

# configure the second public subnet

resource "aws_subnet" "obam-public-subnet2" {
  vpc_id = aws_vpc.obam_vpc
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = true 

      tags = {
      Name = obam-public-subnet2
    }
  

}

# associate public subnet1 to route association

resource "aws_route_table_association" "obam-public-subnet1-association" {

    subnet_id = aws_subnet.obam-public-subnet1.vpc_id
    route_table_id = aws_route_table.obam-route-table-public.id
}

#associte public subnet2 to route association

resource "aws_route_table_association" "obam-public-subnet2-association" {


    subnet_id = aws_subnet.obam-public-subnet1.vpc_id
    route_table_id = aws_route_table.obam-route-table-public.id
  
}

# configure the network ACL

resource "aws_network_acl" "obam-network-acl" {
    vpc_id =  aws_vpc.obam_vpc
    subnet_ids = [ws_subnet1.obam-public-subnet1.id, aws_subnet.obam-public-subnet2.id]


    ingress {
        rule_no = 100
        protocol = "-1"
        action = "aloow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }


egress {
    rule_no = 100
        protocol = "-1"
        action = "aloow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
}


  
}
  

