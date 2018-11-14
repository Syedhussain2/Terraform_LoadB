variable "ami_id" {
  description = "id for db ami "
}

variable "dbname" {
  description = "db name"
}

variable "vpc_id" {
default = "vpc-02ee46f22955a5b81"
}

variable "ig_id" {
     description = "the ig to attach to route tables"
}
