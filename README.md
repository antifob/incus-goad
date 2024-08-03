# GOAD for Incus

Game of Active Directory (GOAD) is a project, by Orange Cyberdefense, to
automate the deployment of vulnerable Active Directory (AD) environments
(called "labs").

This project attempts to streamline the process of deploying a GOAD lab
inside an Incus container.


## Technologies

This project makes use of the following technologies:

- Incus, https://github.com/lxc/incus/
- OpenTofu, https://opentofu.org/
- Ansible, https://ansible.com/


## Requirements

There are two (2) main requirements to this project:

- access to an Incus container running Debian bookworm with:
  - sufficient resources to host your lab's VMs;
  - KVM passthrough for virtualization.
- access to a VM image of each Windows edition used by our lab.

This project is configured to use VM images built with
https://github.com/antifob/incus-windows/


## Usage

The following commands should get you started.

```
# create the lab-hosting container
incus init images:debian/bookworm goad -c security.nesting=true

# resources - 8 CPUs, 16G of RAM, 128G of disk space
incus config set goad limits.cpu=8 limits.memory=16GiB
incus config device override goad root size=128GiB

# kvm passthrough
incus config device add goad kvm unix-char source=/dev/kvm
incus config device add goad vhost-net unix-char source=/dev/vhost-net
incus config device add goad vhost-vsock unix-char source=/dev/vhost-vsock
incus config device add goad vsock unix-char source=/dev/vsock

# start the container
incus start goad
```

Once the lab-hosting container is running, open a shell in it, clone
this project and run the `goad.sh` script.
For example:

```
# run the following commands inside the container using:
# incus exec goad bash

apt-get update
apt-get -y install git

git clone --recurse-submodules --depth=1 https://github.com/antifob/incus-goad
cd incus-goad

# deploy the "GOAD" lab - VM images are stored locally
sh goad.sh GOAD local

# deploy the "GOAD-Light" lab - VM images are stored remotely
# > adds the specified simplestreams remote with the name "r"
# > you must manually edit config.auto.tfvars accordingly
# sh goad.sh GOAD-Light https://images.example.invalid/
```


## VPN Access

If you'd like the container to serve as a VPN entrypoint to the lab,
`tools/setup-wireguard.sh` might be of interest. It automates the
deployment of a WireGuard server for unique 9 clients. Configurations
are made available at `http://<SERVERIP>/`.

```
# in the lab-hosting container
sh ./tools/setup-wireguard.sh
```


## Customization and Development

The setup is rather simple so feel free to take a look at the `goad.sh`
script... I mostly adapted GOAD's proxmox Terraform configuration for
Incus (and made it leaner, doing so). The overall workflow is simply:

- deploy a lab-hosting container;
- install Incus in the container to manage the VMs;
- provision VMs using OpenTofu;
- run Ansible to provision the VMs.

Each of these steps should easily be adaptable to your environment; see
`config.auto.tfvars` and `inventory.yml` (and `inventory.yml` files in
the `labs/` directory).


## Frequently Asked Questions

### How to VMs?

Assuming Incus is running and configured in the lab-hosting container...

```
incus exec goad -- sh -e<<__EOF__
git clone --depth=1 https://github.com/antifob/incus-windows
cd incus-windows

apt-get -y --install-recommends install curl make python3 xorriso

# build the images required by your lab
make 2016
sh ./tools/import.sh ./output/win2016/
make 2019
sh ./tools/import.sh ./output/win2019/

# then, use: sh goad.sh GOAD local
__EOF__
```

### Can I install the lab outside a container?

The lab can be installed on any Incus server, but using a container to
wrap it minimizes the efforts required to integrate it into an existing
environment. If you'd still like to go that route, take a look at the
`config.auto.tfvars` file and the relevant `inventory.yml` file for the
lab you'd like to deploy. You might also want to edit `main.tf` for
additional configuration keys for the VMs.


## References

- https://github.com/Orange-Cyberdefense/GOAD
- https://mayfly277.github.io/categories/proxmox/
