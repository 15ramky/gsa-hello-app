# Service name also acts as a selector
variable "service_name" {
  type = "string"
}

variable "src_port" {
  type = "string"
}
variable "target_port" {
  type = "string"
}
variable "service_type" {
  type    = "string"
  default = "LoadBalancer"
}
