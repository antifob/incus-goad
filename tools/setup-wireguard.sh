#!/bin/sh
#
# Generate a set of WireGuard configurations and server.
#
# usage: $0
#
set -eu

apt-get update
apt-get -y --no-install-recommends install \
	nginx-light \
	wireguard-tools


DESTDIR=/var/www/html


# server

[ -d "${DESTDIR}/0/" ] || mkdir "${DESTDIR}/0/"
cd "${DESTDIR}/0/"

wg genkey | tee privatekey | wg pubkey > publickey

cat>/etc/wireguard/wg0.conf<<__EOF__
[Interface]
Address = 192.168.254.1/24
PrivateKey = $(cat privatekey)
ListenPort = 51820
__EOF__


# clients

for i in 1 2 3 4 5 6 7 8 9; do
	[ -d "${DESTDIR}/${i}" ] || mkdir "${DESTDIR}/${i}/"
	cd "${DESTDIR}/${i}/"

	wg genkey | tee privatekey | wg pubkey > publickey

	cat>wg0.conf<<-__EOF__
	[Interface]
	Address = 192.168.254.$(( i + 100 ))/32
	PrivateKey = $(cat privatekey)

	[Peer]
	PublicKey = $(cat "${DESTDIR}/0/publickey")
	AllowedIPs = 192.168.254.1/32, 192.168.10.0/24
	Endpoint = <SERVERIP>:51820
	PersistentKeepalive = 5
__EOF__
	cat>>/etc/wireguard/wg0.conf<<-__EOF__
	[Peer]
	PublicKey = $(cat publickey)
	AllowedIPs = 192.168.254.$(( i + 100 ))/32
__EOF__

	cat>>"${DESTDIR}/index.html"<<__EOF__
	<a href="${i}/wg0.conf">Client ${i}</a><br/>
__EOF__
done


# service

systemctl enable wg-quick@wg0.service nginx.service
systemctl start wg-quick@wg0.service nginx.service
