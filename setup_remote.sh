#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: setup_remote.sh USERNAME HOSTNAME KEY"
    exit
fi
USERNAME=$1
HOSTNAME=$2
KEY=$3
echo Setting up ${USERNAME}@${HOSTNAME}...
ssh-copy-id -f -i ${KEY} ${USERNAME}@${HOSTNAME}
scp ${KEY} ${USERNAME}@${HOSTNAME}:~/.ssh/$(basename ${KEY})
ssh ${USERNAME}@${HOSTNAME} "chmod 700 ~/.ssh ; chmod 600 ~/.ssh/authorized_keys ; chmod g-w,o-w ~;"
scp .* ${USERNAME}@${HOSTNAME}:~/
echo Done!
