#!/bin/bash


IP="95.214.9.225"

ssh-keygen -f /root/.ssh/known_hosts -R $IP

ssh-keyscan -t rsa -T 10 $IP 2>/dev/null >> /root/.ssh/known_hosts

sshpass -p "yavkin85" scp ./generate_key.sh "root"@$IP:generate_key.sh

sshpass -p "yavkin85" ssh "root"@$IP "./generate_key.sh $1 $2"
