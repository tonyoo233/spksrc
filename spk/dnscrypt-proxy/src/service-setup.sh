SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY=${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy
PID_FILE=${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid
CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"
EXAMPLE_FILES="${SYNOPKG_PKGDEST}/example-*"

SERVICE_COMMAND="${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE}"
SVC_BACKGROUND=y

# rm -drf work-ipq806x-1.1/scripts && make arch-ipq806x-1.1
service_postinst ()
{
    echo "Running post-install script" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}"/var
    if [ ! -e "${CFG_FILE}" ]; then
        cp -f ${EXAMPLE_FILES} "${SYNOPKG_PKGDEST}/var/"
        for file in ${SYNOPKG_PKGDEST}/var/example-*; do
            mv "${file}" "${file//example-/}"
        done

        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        # if empty comment out server list
        wizard_servers=${wizard_servers:-''}
        if [ -z "${wizard_servers// }" ]; then
            server_names_enabled='# '
        fi

        listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT'"}\]
        server_names=\[${wizard_servers:-"'scaleway-fr', 'google', 'yandex', 'cloudflare'"}\]

        # change default settings
        sed -i -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
            -e "s/require_dnssec = .*/require_dnssec = true/" \
            -e "s/# server_names = .*/${server_names_enabled:-""}server_names = ${server_names}/" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
            "${CFG_FILE}" >> "${INST_LOG}"
    fi

    echo "Setting up the Web GUI..." >> "${INST_LOG}"
    ln -s "${SYNOPKG_PKGDEST}/ui" /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy

    ## Allow cgi user to write to this file
    # chown dosn't work as it's overwritten see page 104 in https://developer.synology.com/download/developer-guide.pdf
    # chown system /var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml
    # Less than ideal solution, ToDo: find something better
    chmod 0666 /var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml
    chmod 0666 /var/packages/dnscrypt-proxy/target/var/*.txt
}

service_postuninst ()
{
    rm -f /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy
}
