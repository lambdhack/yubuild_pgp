#!/bin/sh
echo "SCD RANDOM 512" | gpg-connect-agent | sudo tee /dev/random | hexdump -C
