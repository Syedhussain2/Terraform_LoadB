provider "aws" {
region = "eu-west-1"
}
module "app" {
  source = "./modules/app_tier"
  vpc_id = "${var.vpc_id}"
  ig_id  = "${var.ig_id}"
  user_data = "${data.template_file.app_init.rendered}"
}
module "db" {
  source = "./modules/db_tier"
  ami_id = "${var.db_ami_id}"
  dbname = "${var.dbname}"
  ig_id  = "${var.ig_id}"

}
resource "aws_lb_target_group" "syed_target_group"{
  name = "syed-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = "${var.vpc_id}"
  stickiness {
   type = "lb_cookie"
   enabled = false
  }
}
resource "aws_alb_listener" "Syed_listener"{
load_balancer_arn = "${aws_lb.syed_lb.arn}"
port = 80
protocol = "TCP"
default_action{
  type = "forward"
  target_group_arn = "${aws_lb_target_group.syed_target_group.arn}"
}
}
# resource "aws_alb_listener_rule" "syed_lb_listener_rule"{
#   listener_arn = "${aws_lb_listener_rule.Syed_listener.arn}"
# }
# resource "aws_internet_gateway" "default"{
# vpc_id = "${var.vpc_id}"
# tags {
# name = "attachment.vpc-id"}
# }
# hi

data "template_file" "app_init" {
template = "${file("./scripts/app/init.sh.tpl")}"
vars {
db_host="mongodb://${module.db.db-private-ip}:27017/posts"
}
}

resource "aws_lb" "syed_lb" {
  name               = "syed-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-0080335588841a3cd"]

  enable_deletion_protection = false

  tags {
    Environment = "production"
  }
}

resource "aws_launch_configuration" "as_conf" {
  name          = "syed_config"
  image_id      = "ami-055c1755b888344f7"
  user_data = "${data.template_file.app_init.rendered}"
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "syed_group" {
  name                 = "syed-autogroup"
  availability_zones   = ["eu-west-1a"]
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}
