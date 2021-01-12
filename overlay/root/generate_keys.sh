#!/bin/sh

# start pcsc daemon
pcscd

echo "Set the date"

echo -n "date in format YYY.MM.DD-hh:mm (1970.01.01-00:00): "
read DATE
date -s $DATE

echo "Generate a master key with only Certify capabilities"

echo -n "gpg master key passphrase: "
read PASSWORD
echo -n "identity 'Firstname NAME (comment) <email@domain.tld>' : "
read IDENTITY

chmod 600 /root/.gnupg
gpg --batch --passphrase "$PASSWORD" --quick-generate-key "$IDENTITY" rsa4096 cert 0

FINGERPRINT=`gpg --list-key --with-colons | grep "fpr" | cut -d: -f 10`
echo "Generating subkeys for 1y validity"

gpg --pinentry-mode loopback --batch --passphrase "$PASSWORD" --quick-add-key "$FINGERPRINT" rsa4096 auth 1y
gpg --pinentry-mode loopback --batch --passphrase "$PASSWORD" --quick-add-key "$FINGERPRINT" rsa4096 sign 1y
gpg --pinentry-mode loopback --batch --passphrase "$PASSWORD" --quick-add-key "$FINGERPRINT" rsa4096 encr 1y

#echo "generating revocation cert"
#gpg --output $FINGERPRINT.rev --gen-revoke $FINGERPRINT

echo "generating backup keys"
gpg --export --armor $FINGERPRINT > $FINGERPRINT-$(date +%F).pub.asc
gpg --export-secret-keys --armor $FINGERPRINT > $FINGERPRINT-$(date +%F).priv.asc
gpg --export-secret-subkeys --armor $FINGERPRINT > $FINGERPRINT-$(date +%F).sub_priv.asc


echo "Generating and copying backup keys to the usb device"
cryptdev=$(cat < /dev/urandom | tr -dc "[:lower:]"  | head -c 8)

Mapper="/dev/mapper/$cryptdev"
node="/media/temp"

# Set Size of the volume to create 512 MB
size=128

name="toto"

# Create a file-block
base="/dev/shm/$name"
dd if=/dev/zero of="$base" bs=1M count="$size"
mknod -m640 /dev/loop10 b 7 8

# Create a block device from the file-block.
losetup -fP "$base"
loopdev=`losetup -a | grep "$base" | cut -d: -f1`

echo "Creating luks container"
cryptsetup luksFormat -c aes-cbc-essiv:sha256 "$loopdev"

# Setup/open Loop-Device
cryptsetup luksOpen "$loopdev" "$cryptdev"

# Create a file system on volume
mkfs.ext4 "/dev/mapper/$cryptdev"

# mount volume
mkdir "$node"
mount  "/dev/mapper/$cryptdev" "$node"

echo "Copying backup files to luks container"
#echo -n "$PASSWORD" > "$node/gpg_password.txt"
cp $FINGERPRINT-$(date +%F).pub.asc $FINGERPRINT-$(date +%F).priv.asc $FINGERPRINT-$(date +%F).sub_priv.asc $node
sync

umount "$node"
cryptsetup luksClose "/dev/mapper/$cryptdev"
losetup -d "$loopdev"

echo "Copying luks container and public key to usb device"
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb

cp $base $FINGERPRINT-$(date +%F).pub.asc /mnt/usb
sync

umount /mnt/usb


echo "Transfering keys to yubikey"
echo "Assuming you already setup infos (gpg2 --card-edit <passwd, name, login, sex>)"
gpg --card-status

echo "Enter theses command in the following order (you may need to give your yubikey pass):"
echo "---"
echo "toggle"
echo "keytocard"
echo "key 1"
echo "keytocard"
echo "key 1"
echo "key 2"
echo "keytocard"
echo "key 2"
echo "key 3"
echo "keytocard"
echo "key 3"
echo "save"
echo "---"
echo "When saving a key to the card you need to enter your master gpg password then your yubikey admin pass"
echo "---"
gpg --expert --edit-key $FINGERPRINT

gpg --card-status

echo "Congrats, everything is configured!"
