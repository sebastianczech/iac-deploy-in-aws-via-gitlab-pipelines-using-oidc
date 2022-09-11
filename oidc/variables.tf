variable "region" {
  type    = string
  default = "us-east-1"
}

variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_aud" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_thumbprint" {
  type    = string
  default = "b3dd7606d2b5a8b4a13771dbecc9ee1cecafa38a"
}
