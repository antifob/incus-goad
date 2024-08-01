# The Incus server where the lab will be deployed.
#incus_remote = "local"

# The Incus project in which the VMs will be launched.
#incus_project = "default"

# The incus network in which the VMs will be placed.
#incus_network = "incusbr0"

# The location of the various VM images.
# See the Incus image syntax for reference.
incus_images = {
  "win10"   = "remote:windows/10e",
  "win2016" = "remote:windows/2016",
  "win2019" = "remote:windows/2019",
}
