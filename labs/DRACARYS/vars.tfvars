vm_config = {
  "dc01" = {
    name               = "DC01"
    cores              = 2
    memory             = "4GiB"
    image              = "win2025"
    ipv4               = "192.168.10.10"
  }
  "srv01" = {
    name               = "SRV01"
    cores              = 2
    memory             = "4GiB"
    image              = "win2025"
    ipv4               = "192.168.10.11"
  }
  "lx01" = {
    name               = "LX01"
    cores              = 2
    memory             = "4GiB"
    image              = "noble"
    ipv4               = "192.168.10.12"
  }
}
