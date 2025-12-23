variable "img_url_path" {
  default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "vm_name" {
  description = "vm name"
  type = string
  default = "vm-change_me"
}

variable "user_name" {
  type = string
}

variable "user_pw" {
  type        = string
  sensitive   = true
}

variable "vm_memory" {
  type = string
}
variable "vm_vcpu" {
  type = number
}

variable "tf_pool_path" {
  type = string
}

variable "vm_disk_size" {
  type  = string
}

variable "ssh_public_key" {
  type = string
}

variable "network_interface" {
  type  = string
}

variable "ipv4_net_address" {
  type = string
}

variable "tf_ns_search_domain" {
  type = string
}

variable "tf_ns_addresses" {
  type = string
}

variable "tf_ipv4_via_route" {
  type = string
}
