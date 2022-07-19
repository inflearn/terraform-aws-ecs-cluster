variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "FARGATE"

  validation {
    condition     = contains(["EC2", "FARGATE"], var.type)
    error_message = "Variable [type] must be EC2 or FARGATE"
  }
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

variable "protect_from_scale_in" {
  type    = bool
  default = false
}

variable "enabled_metrics" {
  type    = list(string)
  default = null
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

  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.capacity_provider)
    error_message = "Variable [capacity_provider] must be FARGATE or FARGATE_SPOT"
  }
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
