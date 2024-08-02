vm_config = {
  "dc01" = {
    name               = "NHA-DC01"
    cores              = 2
    memory             = "3GiB"
    image              = "win2019"
    ipv4               = "192.168.10.10"
  }
  "dc02" = {
    name               = "NHA-DC02"
    cores              = 2
    memory             = "3GiB"
    image              = "win2019"
    ipv4               = "192.168.10.11"
  }
  "srv01" = {
    name               = "NHA-SRV01"
    cores              = 2
    memory             = "4GiB"
    image              = "win2016"
    ipv4               = "192.168.10.21"
  }
  "srv02" = {
    name               = "NHA-SRV02"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.22"
  }
  "srv03" = {
    name               = "NHA-SRV03"
    cores              = 2
    memory             = "4GiB"
    image              = "win2016"
    ipv4               = "192.168.10.23"
  }
}
