PKG_NAME = iftop
PKG_VERS = 0.17
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ex-parrot.com/pdw/iftop/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/ncurses

HOMEPAGE = http://www.ex-parrot.com/pdw/iftop/
COMMENT  = iftop does for network usage what top(1) does for CPU usage. It listens to network traffic on a named interface and displays a table of current bandwidth usage by pairs of hosts. Handy for answering the question "why is our ADSL link so slow?".
LICENSE  = GPL-2.0

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
