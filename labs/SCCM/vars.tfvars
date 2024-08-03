vm_config = {
  "dc01" = {
    name               = "DC"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.40"
  }
  "srv01" = {
    name               = "MECM"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.41"
  }
  "srv02" = {
    name               = "MSSQL"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.42"
  }
  "ws01" = {
    name               = "CLIENT"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.43"
  }
}
