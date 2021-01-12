################################################################
#
# yubikey-personalization
#
################################################################

# Put here the id of the latest verified valid commit
YUBIKEY_PERSONALIZATION_VERSION = b16b84ffeec1ea8a9ba369c91d19119f5e802682
YUBIKEY_PERSONALIZATION_SITE=$(call github,Yubico,yubikey-personalization,$(YUBIKEY_PERSONALIZATION_VERSION))

YUBIKEY_PERSONALIZATION_INSTALL_STAGING=YES
YUBIKEY_PERSONALIZATION_INSTALL_TARGET=YES
YUBIKEY_PERSONALIZATION_CONF_OPTS=--with-libyubikey-prefix=$(TARGET_DIR)/usr/lib
YUBIKEY_PERSONALIZATION_AUTORECONF=YES
YUBIKEY_PERSONALIZATION_AUTORECONF_OPTS=--install

YUBIKEY_PERSONALIZATION_DEPENDENCIES = libyubikey libjson libusb libxslt

$(eval $(autotools-package))