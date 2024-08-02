vm_config = {
  "dc01" = {
    name               = "SCCM-DC"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.40"
  }
  "srv01" = {
    name               = "SCCM-MECM"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.41"
  }
  "srv02" = {
    name               = "SCCM-MSSQL"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.42"
  }
  "ws01" = {
    name               = "SCCM-CLIENT"
    cores              = 2
    memory             = "4GiB"
    image              = "win2019"
    ipv4               = "192.168.10.43"
  }
}
