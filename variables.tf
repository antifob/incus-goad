variable "vm_config" {
  type = map(object({
    name               = string
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

  default = {
    "win10"   = "local:win10e",
    "win2016" = "local:win2016",
    "win2019" = "local:win2019",
  }
}
