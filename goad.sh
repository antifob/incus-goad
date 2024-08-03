#!/bin/sh
#
# usage: $0 lab remote
#
set -eu

PROGNAME=$(basename -- "${0}")
PROGBASE=$(d=$(dirname -- "${0}"); cd "${d}" && pwd)

usage() {
	printf 'usage: %s [-h] lab remote\n' "${PROGNAME}"
}

while getopts h- argv; do
	case "${argv}" in
	h)	usage
		exit 0
		;;
	-)	break
		;;
	*)	usage >&2
		exit 1
		;;
	esac
	shift $(( OPTIND - 1 ))
done

[ X-- != X"${1:-}" ] || shift

if [ 2 -ne $# ]; then
	usage >&2
	exit 1
fi

if [ ! -d "${PROGBASE}/labs/${1}" ]; then
	printf 'error - unknown lab %s\n' "${1}" >&2
	exit 1
fi

# -------------------------------------------------------------------- #

LAB="${1}"


printf '[+] Installing dependencies\n'

apt-get -y --no-install-recommends install \
	ca-certificates \
	curl \
	python3-venv


if ! command -v tofu >/dev/null; then
	printf '[+] Installing OpenTofu\n'

	curl -fsSL https://get.opentofu.org/opentofu.gpg >/etc/apt/trusted.gpg.d/opentofu.gpg
	curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey >/etc/apt/trusted.gpg.d/opentofu-repo.asc
	echo "deb [signed-by=/etc/apt/trusted.gpg.d/opentofu.gpg,/etc/apt/trusted.gpg.d/opentofu-repo.asc] https://packages.opentofu.org/opentofu/tofu/any/ any main" >/etc/apt/sources.list.d/opentofu.list
	apt-get update
	apt-get -y install tofu
fi


if ! command -v incus >/dev/null; then
	printf '[+] Installing Incus\n'

	curl -fsSL https://pkgs.zabbly.com/get/incus-stable | sh

	incus admin init --minimal
	incus network set incusbr0 ipv4.address=192.168.10.1/24 ipv6.address=none dns.mode=none
	# here, assuming we are running in an unprivileged container
	# we can safely share the parent's idmap
	incus profile set default security.privileged=true

fi

if [ Xlocal != X"${2}" ]; then
	# use a remote
	if incus remote ls -fcsv | grep -q ^r,; then
		# it already exists
		if ! incus remote ls -fcsv | grep -qF "^r,${2},"; then
			# but differs
			incus remote rm r
		fi
	fi
	incus remote add r "${2}" --protocol=simplestreams
fi


printf '[+] Launching VMs\n'

cd "${PROGBASE}"

tofu init
tofu plan  -var-file="labs/${LAB}/vars.tfvars"
tofu apply -var-file="labs/${LAB}/vars.tfvars" -auto-approve


printf '[+] Provisioning VMs\n'

[ -d /opt/ansible/ ] || python3 -mvenv /opt/ansible
. /opt/ansible/bin/activate

pip install -r requirements.txt


cd GOAD/ansible
ansible-galaxy collection install -r requirements.yml

# ordered by priority
ANSIBLE_COMMAND="ansible-playbook -i ../ad/${LAB}/data/inventory -i ../../labs/inventory.yml -i ../../labs/${LAB}/inventory.yml -i ../../inventory.yml -e domain_name=${LAB}"

export ANSIBLE_COMMAND LAB

exec bash ../scripts/provisionning.sh
