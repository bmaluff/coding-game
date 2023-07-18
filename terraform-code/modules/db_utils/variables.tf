variable "subnet_group_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "db_subnet_tags" {
  type = map(string)
}

variable "rds_sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sg_privates" {
  type = list(string)
}

variable "sg_tags" {
  type = map(string)
}