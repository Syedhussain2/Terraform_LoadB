resource "aws_instance" "db_syed" {
ami = "${var.ami_id}"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.syed-private.id}"
vpc_security_group_ids = ["${aws_security_group.syed-db.id}"]
tags {
Name = "${var.dbname}"
}
}

resource "aws_subnet" "syed-private" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.0.15.0/24"
  map_public_ip_on_launch = true


  tags {
    Name = "${var.dbname}"
  }
}

resource "aws_security_group" "syed-db" {
  name        = "syed-db"
  description = "Allow all inbound traffic from app on port 27017 (mongodb)"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.dbname}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.ig_id}"
  }
  tags {
  Name = "${var.dbname}-private_route_table"
  }
}
resource "aws_route_table_association" "private-association" {
subnet_id = "${aws_subnet.syed-private.id}"
route_table_id = "${aws_route_table.private_route_table.id}"
}
