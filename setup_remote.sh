#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: setup_remote.sh USERNAME HOSTNAME PUBKEY"
    exit
fi
USERNAME=$1
HOSTNAME=$2
PUBKEY=$3
echo Setting up ${USERNAME}@${HOSTNAME}...
scp ${PUBKEY} ${USERNAME}@${HOSTNAME}:~/.ssh/authorized_keys
ssh ${USERNAME}@${HOSTNAME} "chmod 700 ~/.ssh ; chmod 600 ~/.ssh/authorized_keys ; chmod g-w,o-w ~;"
scp .* ${USERNAME}@${HOSTNAME}:~/
echo Done!
