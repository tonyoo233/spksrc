service_postinst ()
{
    mkdir -p /usr/local/bin
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/sbin/iftop /usr/local/bin/iftop
}

service_postuninst ()
{
    rm -f /usr/local/sbin/iftop
}
