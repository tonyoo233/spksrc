service_postinst () {
    # Put nmap in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/bin/nmap /usr/local/bin/nmap
}

service_postuninst () {
    # Remove link
    rm -f /usr/local/bin/nmap
}
