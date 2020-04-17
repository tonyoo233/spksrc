PKG_NAME = dotnet-sdk
# PKG_VERS = 3.1.103.2
PKG_VERS = 3.1.201
PKG_EXT = tar.gz
# PKG_DIST_SITE = https://github.com/dotnet/source-build/archive
PKG_DIST_SITE = https://download.visualstudio.microsoft.com/download/pr/f65a8eb0-4537-4e69-8ff3-1a80a80d9341/cc0ca9ff8b9634f3d9780ec5915c1c66
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-x64.$(PKG_EXT)
# PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-sdk

# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore31
DEPENDS =

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = A developer platform for building apps.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
# COMPILE_TARGET = dotnet-compile
# INSTALL_TARGET = nop
INSTALL_TARGET = dotnet-install

include ../../mk/spksrc.native-cc.mk

# .PHONY: dotnet-compile
# dotnet-compile:
# 	$(RUN) ./build.sh

.PHONY: dotnet-install
dotnet-install:
	mkdir -p $(HOME)/.dotnet/
	$(RUN) cp -r ./* $(HOME)/.dotnet/
	$(RUN) ln -s $(HOME)/.dotnet/dotnet $(INSTALL_PREFIX)/bin
