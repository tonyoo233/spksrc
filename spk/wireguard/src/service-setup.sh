service_postinst () {
    # Put wg in the PATH
    mkdir -p /usr/local/bin /usr/local/etc/wireguard >> "${INST_LOG}" 2>&1
    ln -fs /var/packages/${SYNOPKG_PKGNAME}/target/bin/wg /usr/local/bin/wg >> "${INST_LOG}" 2>&1
    insmod /var/packages/${SYNOPKG_PKGNAME}/target/wireguard.ko >> "${INST_LOG}" 2>&1
    lsmod | grep wireguard >> "${INST_LOG}" 2>&1

    cd /usr/local/etc/wireguard || exit 1
    umask 077
    wg genkey | tee privatekey | wg pubkey > publickey
    ip link add dev wg0 type wireguard
}

service_postuninst () {
    # Remove link
    rm -f /usr/local/bin/wg
    rm -rf /usr/local/etc/wireguard
    ip link del wg0
}


# # shellcheck disable=SC2148
# SVC_CWD="${SYNOPKG_PKGDEST}"

# PID_FILE="${SYNOPKG_PKGDEST}/wireguard.pid"
# CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"

# service_postinst ()
# {
#     mkdir -p /usr/local/bin /usr/local/etc/wireguard /opt/lib/modules
#     ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/bin/wg /usr/local/bin/wg
#     cp /var/packages/"${SYNOPKG_PKGNAME}"/target/wireguard.ko /opt/lib/modules/wireguard.ko
#     insmod /opt/lib/modules/wireguard.ko

#     cd /usr/local/etc/wireguard
#     umask 077
#     wg genkey | tee privatekey | wg pubkey > publickey
#     # if [[ -z $PRIVATE_KEY ]]; then
#     #     echo "[+] Generating new private key."
#     #     PRIVATE_KEY="$(wg genkey)"
#     # fi
#     # PRIVATE_KEY=$(wg genkey)
#     # PUBLIC_KEY=$(echo '$SECRET_KEY' | wg pubkey)
# }

#  /usr/syno/etc/rc.d/
# http://hallard.me/how-to-install-kernel-modules-on-synology-ds1010/
# https://hallard.me/how-to-install-kernel-modules-on-synology-ds1010-dsm-4-1/
# ## I need root to bind to port 53 see `service_prestart()` below
# #SERVICE_COMMAND="${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE} &"

# # gen keys
# # umask 077
# # wg genkey | tee privatekey | wg pubkey > publickey
# # SECRET_KEY=$(wg genkey)
# # PUBLIC_KEY=$(echo '$SECRET_KEY' | wg pubkey)

# # ip link add dev wg0 type wireguard
# # ip address add dev wg0 192.168.2.1/24
# # wg setconf wg0 myconfig.conf
# # ip link set up dev wg0

# # if [[ -z $PRIVATE_KEY ]]; then
# #     echo "[+] Generating new private key."
# #     PRIVATE_KEY="$(wg genkey)"
# # fi

# ## SERVER
# # wg0.conf
# [Interface]
# PrivateKey = "$SECRET_KEY"
# Address = 172.22.0.0/24
# ListenPort = 51820
# SaveConfig = true
# # PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i %i -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# # PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i %i -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
# SaveConfig = true

# [Peer]
# PublicKey = {{ wireguard_client_pubkeys.results[(client.item|int)-1].stdout }}
# AllowedIPs = 0.0.0.0/0

# [Peer]
# PublicKey = xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=
# AllowedIPs = 0.0.0.0/0


# wg-quick up wg0
# wg-quick down wg0

# # \clientconfig/
# [Interface]
# PrivateKey ="$(wg genkey)"
# Address = 172.22.0.2/24
# DNS = 192.168.15.1

# [Peer]
# PublicKey = H9bSjJ1hNwZ98EzcBpyBmtTY7ps6IgNSZVbbu2T/Sx8=
# Endpoint = redc.reda.biz:51820
# AllowedIPs = 0.0.0.0/0
# # This is for if you're behind a NAT and
# # want the connection to be kept alive.
# PersistentKeepalive = 25
# # pgrep () {
# #     # shellcheck disable=SC2009,SC2153
# #     ps -w | grep "[^]]$1" >> "${LOG_FILE}" 2>&1
# # }

# # service_prestart () {
# #     echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> "${INST_LOG}"

# #     cd "$SVC_CWD" || exit 1
# # }

# # service_poststop () {
# #     echo "After stop (service_poststop)" >> "${INST_LOG}"
# # }

# # service_postinst () {
# #     echo "Running service_postinst script" >> "${INST_LOG}"
# #     mkdir -p "${SYNOPKG_PKGDEST}"/var >> "${INST_LOG}" 2>&1
# #     if [ ! -e "${CFG_FILE}" ]; then
# #         # shellcheck disable=SC2086
# #         cp -f ${EXAMPLE_FILES} "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
# #         cp -f "${SYNOPKG_PKGDEST}"/offline-cache/* "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
# #         cp -f "${SYNOPKG_PKGDEST}"/blacklist/* "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
# #         for file in ${SYNOPKG_PKGDEST}/var/example-*; do
# #             mv "${file}" "${file//example-/}" >> "${INST_LOG}" 2>&1
# #         done

# #         echo "Applying settings from Wizard..." >> "${INST_LOG}"
# #         ## if empty comment out server list
# #         wizard_servers=${wizard_servers:-""}
# #         if [ -z "${wizard_servers// }" ]; then
# #             server_names_enabled="# "
# #         fi

# #         # Check for dhcp
# #         if pgrep "dhcpd.conf" || netstat -na | grep ":${SERVICE_PORT} "; then
# #             echo "dhcpd is running or port ${SERVICE_PORT} is in use. Switching service port to ${BACKUP_PORT}" >> "${INST_LOG}"
# #             SERVICE_PORT=${BACKUP_PORT}
# #         fi

# #         ## IPv6 address errors with -> bind: address already in use
# #         #listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT', '[::1]:$SERVICE_PORT'"}\]
# #         listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT'"}\]
# #         server_names=\[${wizard_servers:-"'scaleway-fr', 'google', 'yandex', 'cloudflare'"}\]

# #         ## change default settings
# #         sed -i -e "s/# server_names = .*/${server_names_enabled:-""}server_names = ${server_names}/" \
# #             -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
# #             -e "s/# user_name = .*/user_name = '${EFF_USER:-"nobody"}'/" \
# #             -e "s/require_dnssec = .*/require_dnssec = true/" \
# #             -e "s|# log_file = 'dnscrypt-proxy.log'.*|log_file = '${LOG_FILE:-""}'|" \
# #             -e "s/netprobe_timeout = .*/netprobe_timeout = 2/" \
# #             -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
# #             "${CFG_FILE}" >> "${INST_LOG}" 2>&1
# #     fi

# #     echo "Fixing permissions for cgi GUI... on SRM" >> "${INST_LOG}"
# #     # Fixes https://github.com/publicarray/spksrc/issues/3
# #     # https://originhelp.synology.com/developer-guide/privilege/privilege_specification.html
# #     chmod 0777 "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1

# #     blocklist_setup

# #     # shellcheck disable=SC2129
# #     echo "Install Help files" >> "${INST_LOG}"
# #     pkgindexer_add "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
# #     pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
# #     # pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" "${SYNOPKG_PKGDEST}/indexdb/helpindexdb" >> "${INST_LOG}" 2>&1 # DSM 6.0 ?
# # }

# # service_postuninst () {
# #     echo "service_postuninst ${SYNOPKG_PKG_STATUS}" >> "${INST_LOG}"
# #     # shellcheck disable=SC2129
# #     echo "Uninstall Help files" >> "${INST_LOG}"
# #     pkgindexer_del "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
# #     pkgindexer_del "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
# #     disable_dhcpd_dns_port "no"
# #     rm -f /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.conf
# #     rm -f /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.info
# # }

# # service_postupgrade () {
# #     # upgrade script when the offline-cache is also updated
# #     cp -f "${SYNOPKG_PKGDEST}"/blacklist/generate-domains-blacklist.py "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
# # }
