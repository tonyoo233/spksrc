service_postinst ()
{
    mkdir -p /usr/local/sbin
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/sbin/nethogs /usr/local/sbin/nethogs
}

service_postuninst ()
{
    rm -f /usr/local/sbin/nethogs
}
