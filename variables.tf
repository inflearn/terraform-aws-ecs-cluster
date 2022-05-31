variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "EC2"
}

variable "subnets" {
  type    = list(string)
  default = null
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "public_key" {
  type    = string
  default = null
}

variable "ami" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = null
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "target_capacity" {
  type    = number
  default = 90
}

variable "capacity_provider_base" {
  type    = number
  default = 1
}

variable "capacity_provider_weight" {
  type    = number
  default = 1
}

variable "capacity_provider" {
  type    = string
  default = "FARGATE"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "enable_container_insights" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
