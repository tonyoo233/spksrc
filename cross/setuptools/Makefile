PKG_NAME = setuptools
PKG_VERS = 39.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pypa/setuptools/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/pypa/setuptools
COMMENT  = Easily download, build, install, upgrade, and uninstall Python packages
LICENSE  = PSF/ZPL

PRE_CONFIGURE_TARGET = setupools_extra_configure

.PHONY: setupools_extra_configure
setupools_extra_configure:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) bootstrap.py

include ../../mk/spksrc.python-module.mk
