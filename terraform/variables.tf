variable "owner" {}
variable "service" {}
variable "env" {}
variable "image" {}

#AutoScaling
variable "autoscaling_low" {
  default = "20"
}

variable "autoscaling_high" {
  default = "75"
}

variable "health_path" {
  default= "/health"
}

variable "alb_priority" {
  default= 1
}

variable "type_task" {
  default = "EC2"
}

variable "type_targetgroup" {
  default = "instance"
}

variable "type_network" {
  default = "bridge"
}