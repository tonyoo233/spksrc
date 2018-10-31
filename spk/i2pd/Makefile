SPK_NAME = i2pd
SPK_VERS = 2.21.1
SPK_REV = 1
SPK_ICON = src/i2pd.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION  = The I2P network provides strong privacy protections for communication over the Internet. Many activities that would risk your privacy on the public Internet can be conducted anonymously inside I2P.
DISPLAY_NAME = i2pd
CHANGELOG = Initial release

HOMEPAGE   = https://geti2p.net/
HELPURL    = https://i2pd.readthedocs.io/en/latest/
LICENSE    = BSD 3 Clause

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PORT = 7070
SERVICE_PORT = 4444
SERVICE_PORT_TITLE = HTTP-Proxy

include ../../mk/spksrc.spk.mk
