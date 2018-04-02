SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.8
SPK_REV = 0
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2.
RELOAD_UI = no
DISPLAY_NAME = DNSCrypt
# STARTABLE = yes
CHANGELOG = "New version 2 of dnscrypt-proxy"
BETA = 1

HOMEPAGE   = https://github.com/jedisct1/dnscrypt-proxy
LICENSE    = ISC License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

# POST_STRIP_TARGET = dnscrypt_extra_install


include ../../mk/spksrc.spk.mk


# .PHONY: dnscrypt_extra_install
# dnscrypt_extra_install:
# 	install -m 755 -d $(STAGING_DIR)/var
# 	install -m 644 $(STAGING_DIR)/etc/dnscrypt-proxy.conf $(STAGING_DIR)/var/
