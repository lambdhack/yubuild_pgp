# Raspi gpg

A live image to generate gpg key securely.

## softwares

- [gpg](https://gnupg.org/)
- [paperkey](https://www.jabberwocky.com/software/paperkey/)
- [yubikey-manager](https://github.com/Yubico/yubikey-manager)
- [yubikey-personalization](https://github.com/Yubico/yubikey-personalization)
- rng-tools


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

- un systeme pour backup les keys automatiquement sur une cle/carte sd chiffre luks
- importation de cles de backup pour recover en cas de perte
- trng ?
