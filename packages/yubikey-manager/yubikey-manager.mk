################################################################
#
# yubikey-manager
#
################################################################

YUBIKEY_MANAGER_VERSION = 3.1.1
YUBIKEY_MANAGER_SOURCE = yubikey-manager-$(YUBIKEY_MANAGER_VERSION).tar.xz
YUBIKEY_MANAGER_SITE = https://github.com/Yubico/yubikey-manager
YUBIKEY_MANAGER_SETUP_TYPE = distutils

YUBIKEY_MANAGER_DEPENDENCIES = yubikey-personalization

$(eval $(python-package))
