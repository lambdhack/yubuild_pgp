#!/bin/sh

# ID of your gpg key
#export KEYID=0x

gpg --output revoke.asc --gen-revoke $KEYID

cat revoke.asc | hd | while read n; do echo -e -n "${n}\t"; echo "${n}" | cut --delimiter="|" -f2 | cksum; done > revoke.asc.txt


echo "================================="
echo "== BACKUP THE REVOCATION KEY ! =="
echo "================================="

cat revoke.asc.txt

