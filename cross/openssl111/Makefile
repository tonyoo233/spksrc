PKG_NAME = openssl
PKG_VERS = 1.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.openssl.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.openssl.org
COMMENT  = Compression Library
LICENSE  = http://www.openssl.org/source/license.html

CONFIGURE_TARGET = myConfigure

INSTALL_TARGET = myInstall

STAGING_INSTALL_PREFIX := $(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./config --prefix=$(INSTALL_PREFIX) zlib-dynamic shared threads

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install_sw
