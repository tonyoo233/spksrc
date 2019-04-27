# shellcheck disable=SC2129
SERVERPORT=51820
NETWORK=172.23.0.1/24 # why 172.23 ? because Synology SRM uses 172.22 and 172.21 for OpenVPN and L2TP/IPsec
INTERFACE=eth0
# PID_FILE="${SYNOPKG_PKGDEST}/var/wireguard.pid"

if grep -q zsh /etc/shells || grep -q bash /etc/shells; then
    POSIX=0
else
    POSIX=1
fi

config() {
    # if the config does not exist make one
    if [ ! -f "/var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf" ]; then
        DDNS=$(grep -m 1 hostname= /etc/ddns.conf | cut -d = -f 2)
        if [ -n "$DDNS" ]; then
            DDNS=$(dig +short myip.opendns.com @resolver1.opendns.com) || DDNS=$(wget -qO- https://checkip.amazonaws.com)
        fi
        server_privkey=$(wg genkey)
        client_privkey=$(wg genkey)
cat<<EOF > "/var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf"
# NOTICE - Work in Progress
# WireGuard is not yet complete. You should not rely on this code.
# It has not undergone proper degrees of security auditing and the protocol
# is still subject to change. We're working toward a stable 1.0 release,
# but that time has not yet come. There are experimental snapshots tagged
# with "0.0.YYYYMMDD", but these should not be considered real releases and
# they may contain security vulnerabilities (which would not be eligible for CVEs,
# since this is pre-release snapshot software).
# However, if you're interested in helping out, we could really use your help
# and we readily welcome any form of feedback and review.
# There's currently quite a bit of work to do on the project todo list,
# and the more folks testing this out, the better.

[Interface]
Address = $NETWORK
ListenPort = $SERVERPORT
PrivateKey = $server_privkey
SaveConfig = true
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE

# [Peer]
# PublicKey = $(echo "$client_privkey" | wg pubkey)
# AllowedIPs = 172.23.0.2/32 {{select a unique ip inside of $NETWORK}}

## Sample Client Configuration ##
## [Interface]
## PrivateKey = $server_privkey
## Address = 172.23.0.2/32 {{select a unique ip inside of $NETWORK}}
## DNS = 1.1.1.1
##
## [Peer]
## PublicKey = $(echo "$server_privkey" | wg pubkey)
## Endpoint = $DDNS:$SERVERPORT
## AllowedIPs = 0.0.0.0/0, ::0
## # This is for if you're behind a NAT and
## # want the connection to be kept alive.
## PersistentKeepalive = 25
## # Optional
## # MTU = 1432
EOF
    fi
}

config_posix() {
    if [ ! -f "/var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf" ]; then
        config
        sed -i -e '/Address/s/^/#/g' \
            -e '/SaveConfig/s/^/#/g' \
            -e '/PostUp/s/^/#/g' \
            -e '/PostDown/s/^/#/g' \
            /var/packages/"${SYNOPKG_PKGNAME}"/target/etc/wg0.conf
    fi
}

start_posix() {
    # delete and make a new wg0 interface
    ip link del dev wg0 2>/dev/null || true
    ip link add dev wg0 type wireguard

    config_posix

    # load config
    wg setconf wg0 "/var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf"
    # load private key (already set in config file)
    #wg set wg0 private-key "/var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey"
    # give clients an address space
    ip address add dev wg0 ${NETWORK}
    # set a listening port (already set in config file)
    #wg set wg0 listen-port $SERVERPORT
    # start interface
    ip link set up dev wg0

    iptables -A FORWARD -i wg0 -j ACCEPT
    ip6tables -A FORWARD -i wg0 -j ACCEPT
    iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
    ip6tables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
}

stop_posix() {
    ip link set down dev wg0
    iptables -D FORWARD -i wg0 -j ACCEPT
    ip6tables -D FORWARD -i wg0 -j ACCEPT
    iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE
    ip6tables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE
}

service_postinst () {
    # Link binaries into the PATH
    mkdir -p /usr/local/bin "/var/packages/${SYNOPKG_PKGNAME}/target/etc/" >> "${INST_LOG}" 2>&1
    ln -fs "/var/packages/${SYNOPKG_PKGNAME}/target/bin/wg" /usr/local/bin/wg >> "${INST_LOG}" 2>&1
    ln -fs "/var/packages/${SYNOPKG_PKGNAME}/target/bin/wg-quick" /usr/local/bin/wg-quick >> "${INST_LOG}" 2>&1
    # load kernel module and verify that is is loaded
    insmod "/var/packages/${SYNOPKG_PKGNAME}/target/wireguard.ko" >> "${INST_LOG}" 2>&1
    lsmod | grep wireguard >> "${INST_LOG}" 2>&1

    # generate keys
    # [ -f "/var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey" ] || umask 077 && wg genkey | tee "/var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey" | wg pubkey > "/var/packages/${SYNOPKG_PKGNAME}/target/etc/publickey" && umask 022
    # allow synoeditor to read the publickey
    chmod 644 "/var/packages/${SYNOPKG_PKGNAME}/target/etc/publickey"
}

service_prestart() {
    if [ $POSIX = 1 ]; then
        start_posix
    else
        config
        wg-quick up wg0
    fi
}

service_poststop () {
    if [ $POSIX = 1 ]; then
        stop_posix
    else
        wg-quick down wg0
    fi
}

service_postuninst () {
    # Remove link
    rm -f /usr/local/bin/wg
    rm -f /usr/local/bin/wg-quick
    # remove interface
    ip link del wg0 2>/dev/null || true
}
