PKG_NAME = i2pd
PKG_VERS = 2.21.1
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/PurpleI2P/i2pd/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/openssl cross/boost cross/zlib

HOMEPAGE = https://geti2p.net/en/
COMMENT  = The I2P network provides strong privacy protections for communication over the Internet. Many activities that would risk your privacy on the public Internet can be conducted anonymously inside I2P.
LICENSE  = BSD 3 Clause

CONFIGURE_TARGET = i2pd-configure

include ../../mk/spksrc.cross-cc.mk

BOOST_CMD=echo $(WORK_DIR)/boost_*
BOOST_DIR=$(shell $(BOOST_CMD))

OPENSSL_CMD=echo $(WORK_DIR)/openssl-*
OPENSSL_DIR=$(shell $(OPENSSL_CMD))

ZLIB_CMD=echo $(WORK_DIR)/zlib-*
ZLIB_DIR=$(shell $(ZLIB_CMD))

# https://i2pd.readthedocs.io/en/latest/devs/building/cross/
.PHONY: i2pd-configure
i2pd-configure:
	$(RUN) CXXFLAGS=-O2 cmake –G"Unix Makefiles" build \
		-DOPENSSL_ROOT_DIR=$(OPENSSL_DIR) \
		-DZLIB_ROOT=$(ZLIB_DIR) \
		-DBOOST_ROOT=$(BOOST_DIR) \
		-DCMAKE_PREFIX_PATH=$(WORK_DIR)/install/var/packages/i2pd/target/lib/pkgconfig \
		-DWITH_HARDENING=ON \
		-DWITH_STATIC=ON \
		-DWITH_LIBRARY=OFF \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)
