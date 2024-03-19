variable "name" {}
variable "cidr" {}
variable "public_subnets" { default = [] }
variable "private_subnets" { default = [] }
variable "bastion_instance_id" {}
variable "azs" { type = "list" }
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

# resources
resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags {
    Name = "${var.name}"
  }
  tags = {
    yor_trace = "6b70af92-981b-4c2f-b86b-b9af6cd7a6cb"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags = {
    yor_trace = "bb7a4c3f-da75-483a-99f7-8498561b932d"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mod.id}"
  }
  tags {
    Name = "${var.name}-public"
  }
  tags = {
    yor_trace = "8789da67-d637-41eb-9166-950cb9213d93"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${var.bastion_instance_id}"
  }
  tags {
    Name = "${var.name}-private"
  }
  tags = {
    yor_trace = "540bc6d1-75f7-4240-b1a3-6c1e7ca280c7"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.private_subnets)}"
  tags {
    Name = "${var.name}-private"
  }
  tags = {
    yor_trace = "fcd8c80b-ddb0-4740-b618-90a186c2e458"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnets)}"
  tags {
    Name = "${var.name}-public"
  }

  map_public_ip_on_launch = true
  tags = {
    yor_trace = "948de6bc-e2d1-4edf-bb63-6c00eccc5865"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# outputs
output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}
output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}
output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}
output "vpc_cidr_block" {
  value = "${aws_vpc.mod.cidr_block}"
}
