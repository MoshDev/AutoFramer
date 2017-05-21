#!/bin/bash
# set -e

echo -n "Please enter host machine ip address:"
read host_ip_address

[ -z $host_ip_address ] && echo "Invalid host ip address" && exit 1

echo -n "Please enter host alias name:"
read host_alias

[ -z $host_alias ] && echo "Invalid host alias" && exit 1 

echo -n "Please enter the username to be created on remote machine:"
read username

[ -z $username ] && echo "Invalid username" && exit 1

# Android sdk setup
ssh -oStrictHostKeyChecking=no root@$host_ip_address 'bash -s' <scripts/android_sdk_frame.sh

# Create user ssh key & remote host alias
bash $(pwd)/scripts/ssh_local_framer.sh $host_ip_address $host_alias $username

# Add created user to the remote machine
user_ssh_key_content=$(cat ~/.ssh/id_rsa_$username.pub)
scp scripts/remote_machine_setup.sh root@$host_ip_address:/root

ssh -oStrictHostKeyChecking=no root@$host_ip_address <<EOF
bash remote_machine_setup.sh $username "$user_ssh_key_content"
EOF

# ssh -oStrictHostKeyChecking=no root@$host_ip_address 'bash -s' $username "$user_ssh_key_content" <scripts/remote_machine_setup.sh

# Testing connection
ssh $host_alias <<EOF
echo "XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX"
echo "printing from remote machine, means we are connected successfully"
echo "XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX"
EOF

current_user=$(whoami)
autoframer_preferences=/Users/$current_user/Library/Autoframer
mkdir -p $autoframer_preferences

cp -r scripts/mainframer/ $autoframer_preferences

echo -e "remote_machine=$host_alias
local_compression_level=5
remote_compression_level=5" > $autoframer_preferences/.mainframer/config

cp scripts/autoframer_setup.sh /usr/local/bin/
mv /usr/local/bin/autoframer_setup.sh /usr/local/bin/autoframer


echo "Setup is finished
all you need to run 'bash autoframer' from you project directory
---
also you can ssh the remote maching using: ssh $host_alias
"
