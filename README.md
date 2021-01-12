# Raspi gpg

A live raspberry pi 3 image to generate gpg key securely and import it to yubikey.

The live image has been generated using buildroot with this latest release `2020.11.1, released December 27th, 2020`.

## softwares

- [gpg](https://gnupg.org/)
- [yubikey-manager](https://github.com/Yubico/yubikey-manager)
- [yubikey-personalization](https://github.com/Yubico/yubikey-personalization) -> not working

# Usage

### `./generate_keys.sh`

Do the first generation of the key :

- Generates master pgp key
- Creates Sign Encrypt Authenticate subkey certified by the master key
- Copy the public key to the usb key
- backup private keys in encrypted luks container and copy it to a usb key

/!\ Before running the script you should plug in the rpi the yubikey and a usb key

### `./renew_subkeys.sh`

Renew subkeys on the yubikey

/!\ Before running the script you should plug in the rpi the yubikey and a usb key with the backup luks volume

# TODO

- make scripts more user friendly
- trng support
- fix yubikey-personalization package
- add paperkey package ?

# More ?

follow this [guide](https://github.com/drduh/YubiKey-Guide).
