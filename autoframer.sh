#!/bin/bash
set -xe

# getting user input

echo -n "Type the remote machine IP address, followed by [ENTER]:"
read remote_host_ip

if [ -z $remote_host_ip]; then
	remote_host_ip="46.101.40.213"
fi

echo -n "Type the remote machine username (empty for root), followed by [ENTER]:"
read remote_host_user

if [ -z $remote_host_user]; then
	echo "Using user \"root\""
	remote_host_user="root"
fi

# connects to remote machine

ssh -oStrictHostKeyChecking=no $remote_host_user@$remote_host_ip <<EOF

echo && echo "updating apt" && echo && sleep 2

# update apt on remote machine
apt-get -y update 

echo && echo "installing OpenJdk 8" && echo && sleep 2

# install jdk8
apt-get -y install openjdk-8-jdk

echo && echo "installing unzip tool" && echo && sleep 2

# install unzip tool
apt-get -y install unzip
    
echo && echo "downloading linux android sdk tools" && echo && sleep 2
# download android linux sdk tools
wget -N -O sdk-tools-linux.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

echo && echo "creating our own sdk directory (android-sdk)" && echo && sleep 2

# create sdk directory
mkdir android-sdk

echo && echo "unzipping linux android sdk tools" && echo && sleep 2

# unzip android linux sdk tools
unzip -o sdk-tools-linux.zip -d android-sdk/

echo && echo "navigating into android-sdk dir" && echo && sleep 2

# navigate into our directory
cd android-sdk/
pwd

EOF

echo $0
