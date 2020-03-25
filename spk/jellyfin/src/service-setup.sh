# Package specific behaviours
# Sourced script by generic installer and start-stop-status scripts

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/jellyfin" -d ${SYNOPKG_PKGDEST}/var/data -C ${SYNOPKG_PKGDEST}/var/cache -c ${SYNOPKG_PKGDEST}/var/config -l ${SYNOPKG_PKGDEST}/var/log -w ${SYNOPKG_PKGDEST}/web

# CFG_FILE="${SYNOPKG_PKGDEST}/var/jellyfin.yml"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
