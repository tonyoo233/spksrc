PKG_NAME = nethogs
PKG_VERS = 0.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/raboof/nethogs/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/ncurses

HOMEPAGE = https://github.com/raboof/nethogs
COMMENT  = NetHogs is a small 'net top' tool. Instead of breaking the traffic down per protocol or per subnet, like most tools do, it groups bandwidth by process.
LICENSE  = GPL-2.0

export PREFIX=$(STAGING_INSTALL_PREFIX)

CONFIGURE_TARGET = nethogs_configure
COMPILE_TARGET = nethogs_compile
.PHONY: nethogs_configure nethogs_compile

nethogs_configure: install # strangely this works

nethogs_compile: nethogs_configure
	$(RUN) $(MAKE) nethogs

include ../../mk/spksrc.cross-cc.mk
