PKG_NAME = setuptools
PKG_VERS = 40.6.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/s/$(PKG_NAME)
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
