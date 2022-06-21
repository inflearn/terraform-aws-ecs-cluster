variable "name" {
  type = string
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
  type = string
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
  default = 0
}

variable "max_size" {
  type    = number
  default = 1
}

variable "protect_from_scale_in" {
  type    = bool
  default = false
}

variable "managed_termination_protection" {
  type    = string
  default = "DISABLED"
}

variable "target_capacity" {
  type    = number
  default = 90
}

variable "capacity_provider" {
  type    = string
  default = "FARGATE"
}

variable "capacity_provider_base" {
  type    = number
  default = 1
}

variable "capacity_provider_weight" {
  type    = number
  default = 1
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "enable_container_insights" {
  type    = bool
  default = true
}

variable "root_block_device" {
  type    = list(any)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
