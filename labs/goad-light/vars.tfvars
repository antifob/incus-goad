vm_config = {
  "dc01" = {
    name               = "GOAD-DC01"
    cores              = 2
    memory             = "3GiB"
    image              = "win2019"
    ipv4               = "192.168.10.10"
  }
  "dc02" = {
    name               = "GOAD-DC02"
    cores              = 2
    memory             = "3GiB"
    image              = "win2019"
    ipv4               = "192.168.10.11"
  }
  "srv02" = {
    name               = "GOAD-SRV02"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.22"
  }
}
