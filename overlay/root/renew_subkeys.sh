#!/bin/sh

echo "Set the date"

echo -n "date in format YYY.MM.DD-hh:mm (1970.01.01-00:00): "
read DATE
date -s $DATE


echo "Mounting the usbkey"
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb

ls -al /mnt/usb

echo -n "Enter the name of the luks container on the usb key: "
read LUKS_FILE

mknod -m640 /dev/loop10 b 7 8
losetup -fP "/mnt/usb/$LUKS_FILE"
loopdev=`losetup -a | grep "$LUKS_FILE" | cut -d: -f1`

# Setup/open Loop-Device
cryptdev=yubi
cryptsetup luksOpen "$loopdev" "$cryptdev"

# mount volume
luks_mnt="/mnt/yubi"
mkdir "$luks_mnt"
mount  "/dev/mapper/$cryptdev" "$luks_mnt"

echo "importing private keys"
ls -al "$luks_mnt"
echo -n "Enter the name of the file containing the private keys: "
read GPG_PRIV
gpg --import "$luks_mnt/$GPG_PRIV"

FINGERPRINT=`gpg --list-key --with-colons | grep "fpr" | cut -d: -f 10 | head -n 1`

echo "Renewing subkeys"

echo "Enter theses command in the following order (you may need to give your yubikey pass):"
echo "---"
echo "key 1"
echo "key 2"
echo "key 3"
echo "expire -> set new expiration date (1y)"
echo "quit"
echo "---"
echo "When saving a key to the card you need to enter your master gpg password then your yubikey admin pass"
echo "---"
gpg --edit-key $FINGERPRINT

echo "Exporting updated keys"
gpg --export $FINGERPRINT > $FINGERPRINT-$(date +%F).pub.asc
sync

umount "$luks_mnt"
cryptsetup close "$cryptdev"
