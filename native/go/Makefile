PKG_NAME = go
PKG_VERS = 1.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/golang
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go-1.4

HOMEPAGE   = http://golang.org/
COMMENT    = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE    =

CONFIGURE_TARGET = nop
COMPILE_TARGET = myComp
INSTALL_TARGET = nop

GOROOT_BOOTSTRAP=$(WORK_DIR)/../../go/work-native/go
GOROOT_BOOTSTRAP14=$(WORK_DIR)/../../go-1.4/work-native/go

include ../../mk/spksrc.native-cc.mk

# https://golang.org/doc/install/source
myComp:
	@$(MSG) "Building Go"
	@$(MSG) "Building Go for amd64 (x86-64) [host system]"
	cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=amd64 GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP14) ./make.bash
	@$(MSG) "Building Go for 386 (x86 or x86-32) "
	cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=386 GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	@$(MSG) "Building Go for arm"
	cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=arm GOARM=5 GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	# @$(MSG) "Building Go for arm64"
	# cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=arm64 GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	@$(MSG) "Building Go for ppc64 (PowerPC)"
	cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=ppc64 GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	# @$(MSG) "Building Go for ppc64le (PowerPC little-endian)"
	# cd/ $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=ppc64le GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	# @$(MSG) "Building Go for mips (32-bit)"
	# cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=mips GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	# @$(MSG) "Building Go for mipsle (32-bit little-endian)"
	# cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH=mipsle  GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
