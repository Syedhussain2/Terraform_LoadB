output "db-private-ip"{
  value = "${aws_instance.db_syed.private_ip}"
}
