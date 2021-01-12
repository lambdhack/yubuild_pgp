################################################################
#
# libyubikey
#
################################################################

# Put here the id of the latest verified valid commit
LIBYUBIKEY_VERSION = 0b8aabe145c4ddcb3a6cce2d5392e9555eb01f4f
LIBYUBIKEY_SITE=$(call github,Yubico,yubico-c,$(LIBYUBIKEY_VERSION))

LIBYUBIKEY_INSTALL_STAGING=YES
LIBYUBIKEY_INSTALL_TARGET=YES
LIBYUBIKEY_AUTORECONF=YES
LIBYUBIKEY_AUTORECONF_OPTS=--install

$(eval $(autotools-package))
