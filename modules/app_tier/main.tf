
resource "aws_instance" "app_syed" {
ami = "${var.app_ami_id}"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.syed_subnet.id}"
vpc_security_group_ids = ["${aws_security_group.syed_security_group.id}"]
user_data = "${var.user_data}"
tags {
Name = "${var.appname}"
}
key_name = "DevOpsStudents"
}
resource "aws_subnet" "syed_subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.appname}"
  }
}
resource "aws_security_group" "syed_security_group" {
  name        = "syed_security_group"
  description = "Allow all inbound traffic from anywhere on port 80"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.appname}"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.ig_id}"
  }
  tags {
  Name = "${var.appname}-public_route_table"
  }
}
resource "aws_route_table_association" "association" {
subnet_id = "${aws_subnet.syed_subnet.id}"
route_table_id = "${aws_route_table.public_route_table.id}"

}
