variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "worker-count" {
  type    = number
  default = 1
}

variable "webserver-port" {
  type    = number
  default = 8080
}

#variable "dns-name" {
#	type = string
#	default = "the Name value you copied in Line 3 above"
#}
