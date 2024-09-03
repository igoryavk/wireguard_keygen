#!/bin/bash

#
# Script for generate users public and private keys
#

USERNAME=$1
FOLDER="/etc/wireguard/users"
IP=$2


echo -e "\033[92m This is script for automation generation of wireguard keys \033[0m"

if [ -e $FOLDER ]
then
	echo "Users folder exists, we are ready to start"
else
	mkdir $FOLDER
fi

if [ "x$USERNAME" == "x" ] && [ "x$IP" == "x" ]; then 
	echo "Please check username and ip-address the username for generation key"
else
	#echo "${FOLDER}/${USERNAME}_private"  
	wg genkey | tee "${FOLDER}/${USERNAME}_private" | wg pubkey | tee "${FOLDER}/${USERNAME}_public"
        
	PUBKEY=`cat "${FOLDER}/${USERNAME}_public"`
	echo $PUBKEY

	echo "[Peer]" >> /etc/wireguard/wg0.conf
	echo "PublicKey = ${PUBKEY}" >> /etc/wireguard/wg0.conf
	echo "AllowedIPs = ${IP}" >> /etc/wireguard/wg0.conf

        PRIVATEKEY=`cat "${FOLDER}/${USERNAME}_private"`
        
	echo "[Interface]" > "${FOLDER}/${USERNAME}.conf"
	echo "PrivateKey = ${PRIVATEKEY}" >> "${FOLDER}/${USERNAME}.conf"
	echo "Address = ${IP}/24" >> "${FOLDER}/${USERNAME}.conf"
	echo "DNS = 8.8.8.8" >> "${FOLDER}/${USERNAME}.conf"
   

	echo "" >> "${FOLDER}/${USERNAME}.conf"

	
	echo "[Peer]" >> "${FOLDER}/${USERNAME}.conf"


	SERVER_PUBKEY=`cat /etc/wireguard/server_public`

	echo "PublicKey = ${SERVER_PUBKEY}" >> "${FOLDER}/${USERNAME}.conf"
        echo "AllowedIPs = 0.0.0.0/0" >> "${FOLDER}/${USERNAME}.conf"
	echo "EndPoint = 95.214.9.225:5114" >> "${FOLDER}/${USERNAME}.conf"
	echo "PersistentKeepalive = 20" >> "${FOLDER}/${USERNAME}.conf"

	
fi	
