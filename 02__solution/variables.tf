variable "cluster_name" {
  default = "challenge-cluster"
}

variable "account_id" {
  description = "AccountID aws"
}

variable "region" {
  description = "Region aws"
}

variable "application" {
  description = "Application to deploy"
}

variable "tag" {
  description = "Tag to apply"
}