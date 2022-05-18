variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "pubkey" {
  type     = string
  nullable = false
}

variable "account_id" {
  type = string
}
