terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
    }
  }
}

provider "incus" {
  remote { name = var.incus_remote }
}

resource "incus_instance" "lab" {
  for_each = var.vm_config

    remote  = var.incus_remote
    project = var.incus_project

    name = each.value.name
    description = each.value.image
    type = "virtual-machine"
    image = var.incus_images[each.value.image]

    limits = {
      cpu = each.value.cores
      memory = each.value.memory
    }

    device {
      name = "eth0"
      type = "nic"
      properties = {
        network = var.incus_network
        "ipv4.address" = each.value.ipv4
      }
    }
}
