PKG_NAME = libcap
PKG_VERS = 2.25
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# PKG_DIST_SITE = https://git.kernel.org/pub/scm/linux/kernel/git/morgan/libcap.git/snapshot
PKG_DIST_SITE = https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://git.kernel.org/pub/scm/linux/kernel/git/morgan/libcap.git
# changlog: https://sites.google.com/site/fullycapable/release-notes-for-libcap
COMMENT  = This is a library for getting and setting POSIX.1e (formerly POSIX 6) draft 15 capabilities.
LICENSE  = GPL-2.0

CONFIGURE_TARGET = nope
COMPILE_TARGET = libcap_compile
COMPILE_INSTALL = libcap_install
.PHONY: libcap_install libcap_compile


libcap_compile:
	echo "-------- _makenames --------"
	$(RUN) $(MAKE) -C libcap _makenames CC="cc" # use the systems host compiler
	echo "-------- libcap.a libcap.so.$(PKG_VERS) --------"
	$(RUN) $(MAKE) -C libcap libcap.a libcap.so."$(PKG_VERS)" libcap.pc CC="$(CC)" LDSHARED="$(LDSHARED)" AR="$(AR)" RANLIB="$(RANLIB)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
	echo "-------- progs --------" # getpcaps fails
	$(RUN) $(MAKE) -C progs capsh getcap setcap CC="$(CC)" LD="$(LD)" LDSHARED="$(LDSHARED)" AR="$(AR)" RANLIB="$(RANLIB)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

libcap_install: libcap_compile
	echo "-------- install --------"
	$(RUN) mkdir -p -m 0755 "$(STAGING_INSTALL_PREFIX)/sbin"
	$(RUN) install -m 0755 progs/capsh "$(STAGING_INSTALL_PREFIX)/sbin/capsh"
	$(RUN) install -m 0755 progs/getcap "$(STAGING_INSTALL_PREFIX)/sbin/getcap"
	$(RUN) install -m 0755 progs/setcap "$(STAGING_INSTALL_PREFIX)/sbin/setcap"

include ../../mk/spksrc.cross-cc.mk

# cross compiling is hard:
# https://lists.gnu.org/archive/html/ltib/2011-09/msg00063.html
# https://lists.gnu.org/archive/html/ltib/2011-09/msg00070.html

# security is hard: https://github.com/golang/go/issues/1435
