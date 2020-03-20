variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections"
  type        = string
  default     = "centos"
}

variable "private_deploy_key" {}

variable "public_deploy_key" {}
