variable "A-key" {
    default = "AKIAU6GDWMSZJZLNZZEU"
}
variable "S-key" {
    default = "zJJh7YFyAqoRxLTSDm9EY8FOgbgKALekOlnb/UP3"
}
variable "vpc-cidr" {
    default = "10.0.0.0/16"
}

variable "subA-cidr" {
    default = "10.0.1.0/24"
}

variable "zoneA" {
    default = "ap-south-1a"

}

variable "ami" {
    default = "ami-06b72b3b2a773be2b"
}

variable "instance_type" {
    default = "t2.micro"
}
