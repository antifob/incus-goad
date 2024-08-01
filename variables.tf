variable "vm_config" {
  type = map(object({
    name               = string
    desc               = string
    cores              = number
    memory             = string
    image              = string
    ipv4               = string
  }))
}


variable "incus_remote" {
  type = string
  default = "local"
}
variable "incus_project" {
  type = string
  default = "default"
}
variable "incus_network" {
  type = string
  default = "incusbr0"
}
variable "incus_images" {
  type = map(string)
}
