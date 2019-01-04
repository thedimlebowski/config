#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: setup_remote.sh USERNAME HOSTNAME PUBKEY"
    exit
fi
USERNAME=$1
HOSTNAME=$2
PUBKEY=$3
echo Setting up ${USERNAME}@${HOSTNAME}...
ssh-copy-id -f -i ${PUBKEY} ${USERNAME}@${HOSTNAME}
scp .* ${USERNAME}@${HOSTNAME}:~/
echo Done!
