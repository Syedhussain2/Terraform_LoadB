variable "appname" {
default = "app_syed"
}
variable "app_ami_id" {
default = "ami-055c1755b888344f7"
}
variable "vpc_id" {
default = "vpc-02ee46f22955a5b81"
}
variable "dbname" {
default = "db_syed"
}
variable "db_ami_id" {
default = "ami-052d4b45126cc68ec"
}
variable "rt_id" {
default = "rtb-04111afd8b122389c"
}
variable "ig_id" {
     description = "the ig to attach to route tables"
}

variable "user_data" {
     description = "the user data to provide to the instance"
     default = ""
}
