SPK_NAME = i2pd
SPK_VERS = 2.19.0
SPK_REV = 1
SPK_ICON = src/i2pd.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION  = The I2P network provides strong privacy protections for communication over the Internet. Many activities that would risk your privacy on the public Internet can be conducted anonymously inside I2P.
RELOAD_UI = no
DISPLAY_NAME = i2pd
STARTABLE = no
CHANGELOG = Initial release

HOMEPAGE   = https://geti2p.net/
LICENSE    = BSD 3 Clause

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PORT = 7070
SERVICE_PORT = 4444
SERVICE_PORT_TITLE = HTTP-Proxy

include ../../mk/spksrc.spk.mk
